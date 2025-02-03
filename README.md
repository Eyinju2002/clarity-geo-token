# GeoToken
A decentralized platform for real-time location sharing using blockchain technology.

## Features
- Mint GeoTokens representing location data
- Transfer tokens between users
- Store location coordinates securely on-chain
- Query location history
- Authorization controls for location sharing
- Prevention of duplicate token IDs

## Usage
The GeoToken contract allows users to:
1. Create and manage tokens
- mint-token: Mint a new token with unique ID
- record-location: Store location coordinates
- update-location: Update existing location data
2. Share location access
- grant-access: Give another user permission to view locations
- revoke-access: Remove location viewing permission
3. Query location data
- get-location: Get latest location for a token
- get-location-history: Get historical locations

## Recent Updates
- Added explicit token minting functionality
- Added prevention of duplicate token IDs
- Updated testing suite to verify token minting
