#!/usr/bin/env ruby

require 'jwt'
require 'openssl'
require 'yaml'
require 'fileutils'

# Function to create configuration file if it doesn't exist
def create_default_config(config_path)
 # default_config = {
 #   'key_file' => '',
 #   'team_id' => '',
 #   'client_id' => '',
 #   'key_id' => '',
 #   'validity_period' => 180
 # }
  
  FileUtils.mkdir_p(File.dirname(config_path))
  File.open(config_path, 'w') do |file|
    file.write(default_config.to_yaml)
  end
  
  puts "Created default configuration at #{config_path}"
  puts "Please update the key_file path and verify other settings."
  exit 1
end

# Load configuration
config_path = File.join(File.dirname(__FILE__), 'config.yml')
create_default_config(config_path) unless File.exist?(config_path)

begin
  config = YAML.load_file(config_path)
rescue => e
  puts "Error loading configuration: #{e.message}"
  exit 1
end

# Extract configuration values
key_file = config['key_file']
team_id = config['team_id']
client_id = config['client_id']
key_id = config['key_id']
validity_period = config['validity_period']

# Validate configuration
if key_file.nil? || key_file.include?('/path/to/your/')
  puts "Error: Please update the key_file path in config.yml"
  exit 1
end

# Expand the key_file path if it's relative
unless key_file.start_with?('/') || key_file =~ /\A[A-Za-z]:\\/
  # Assuming the script is in the same directory as the key file
  key_file = File.join(File.dirname(__FILE__), key_file)
end

begin
  # Check if the key file exists
  unless File.exist?(key_file)
    puts "Error: Key file not found at #{key_file}"
    exit 1
  end

  # Load the private key
  private_key = OpenSSL::PKey::EC.new(IO.read(key_file))

  # Generate the token
  token = JWT.encode(
    {
      iss: team_id,
      iat: Time.now.to_i,
      exp: Time.now.to_i + 86400 * validity_period,
      aud: "https://appleid.apple.com",
      sub: client_id
    },
    private_key,
    "ES256",
    {
      kid: key_id
    }
  )

  puts "Generated Apple Sign In JWT Token:"
  puts token
  puts "\nThis token will expire in #{validity_period} days."
  
  # Optionally save the token to a file
  token_file = File.join(File.dirname(__FILE__), 'current_token.txt')
  File.write(token_file, token)
  puts "Token has been saved to #{token_file}"

rescue => e
  puts "Error generating token: #{e.message}"
  puts e.backtrace.join("\n") if ENV['DEBUG']
  exit 1
end
