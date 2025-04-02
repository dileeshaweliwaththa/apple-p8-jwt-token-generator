# Apple Sign In JWT Token Generator

This tool generates JWT tokens required for Apple Sign In server-to-server authentication.

## Prerequisites

- Ruby (2.5 or newer)
- The following Ruby gems:
  - jwt
  - openssl

## Installation

1. Install required gems:

```bash
gem install jwt
```

2. Place your Apple private key file (`.p8`) in this directory or update the `config.yml` 
   with the correct path to your key file.

## Configuration

All settings are stored in `config.yml`:

- `key_file`: Path to your private key file (`.p8`)
- `team_id`: Your Apple Developer Team ID
- `client_id`: Your Services ID (also called Client ID)
- `key_id`: The Key ID for your private key
- `validity_period`: How long the token should be valid (in days, max 180)

## Usage

Run the script:

```bash
ruby generate_apple_token.rb
```

The script will:
1. Generate a JWT token
2. Display the token in the console
3. Save the token to `current_token.txt`

## Detailed Running Instructions

1. **Setup Environment**:
   - Make sure Ruby is installed on your system (check with `ruby -v`)
   - Navigate to the application directory:
     ```
     cd "d:\UPVIEW\Create acccestoken from p8"
     ```

2. **Install Dependencies**:
   - Using Bundler (recommended):
     ```
     bundle install
     ```
   - Without Bundler:
     ```
     gem install jwt
     ```

3. **Prepare Your Key File**:
   - Copy your `.p8` key file to the application directory OR
   - Update the `key_file` setting in `config.yml` with the absolute path to your key file

4. **Verify Configuration**:
   - Double-check that all values in `config.yml` match your Apple Developer credentials:
     - `team_id`: Your Apple Developer Team ID
     - `client_id`: Your Services ID
     - `key_id`: The Key ID for your private key

5. **Run the Application**:
   ```
   ruby generate_apple_token.rb
   ```

6. **Check Results**:
   - The JWT token will be displayed in the console
   - A copy of the token will be saved to `current_token.txt` in the same directory
   - The token is valid for the number of days specified in `config.yml`

7. **Using the Token**:
   - Copy the generated token for use in your API requests or client applications
   - Remember that this token expires based on your `validity_period` setting

## Troubleshooting

If you encounter issues:

- Verify your private key file path is correct
- Ensure all values in `config.yml` match those in your Apple Developer account
- Check that your private key hasn't expired
- For more detailed error messages, run with debug mode:
  ```
  DEBUG=true ruby generate_apple_token.rb
  ```

## References

- [Apple Sign In Documentation](https://developer.apple.com/documentation/sign_in_with_apple/generate_and_validate_tokens)
