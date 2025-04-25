#!/bin/bash

# Configuration
API_URL="${API_URL:-http://localhost:5500}"  # Default to localhost if not set
ACCESS_TOKEN="${ACCESS_TOKEN}"  # Must be set in environment

# Check if ACCESS_TOKEN is set
if [ -z "$ACCESS_TOKEN" ]; then
    echo "Error: ACCESS_TOKEN environment variable is not set"
    exit 1
fi

echo "Starting missing ideal candidates check process..."

# Make the API request
response=$(curl -s -X POST \
    -H "Authorization: Bearer $ACCESS_TOKEN" \
    -H "Content-Type: application/json" \
    "$API_URL/check-missing-ideal-candidates")

# Check if curl command succeeded
if [ $? -ne 0 ]; then
    echo "Error: Failed to connect to API. Tried $API_URL"
    exit 1
fi

# Parse and display the response
status=$(echo "$response" | jq -r '.status // empty')
message=$(echo "$response" | jq -r '.message // empty')
error=$(echo "$response" | jq -r '.error // empty')

if [ ! -z "$error" ]; then
    echo "Error: $error"
    exit 1
fi

if [ "$status" = "success" ]; then
    echo "Success: $message"
    exit 0
else
    echo "Unexpected response:"
    echo "$response" | jq '.'
    exit 1
fi