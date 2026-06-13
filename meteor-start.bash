#!/usr/bin/env bash
# Start a built Meteor bundle located at ~/bundle.
# Assumes MongoDB is running locally on 27017 with db 'myapp'.
# Edit PORT / MONGO_URL / ROOT_URL for your setup.

cd ~
cd bundle
(cd programs/server && npm install)
PORT=3001 MONGO_URL=mongodb://localhost:27017/myapp ROOT_URL=http://localhost node main.js

