# Stage 1 or builder
FROM node:12-alpine3.10 as builder

# Create the app directory
WORKDIR /usr/app

# Install app dependencies
# The wildcard is used to ensure both package.json and package-lock.json are copied
# where available
COPY package*.json ./

RUN yarn install

# Bundle app source
COPY . .

# Transpile from TS to JS to a /usr/app/dist directory
RUN yarn build


#################
# Stage 2
#################
FROM node:12-alpine3.10

RUN apk --no-cache add tini
# Tini is now available at /sbin/tini
ENTRYPOINT ["/sbin/tini", "--"]

WORKDIR /usr/app

COPY package*.json ./

RUN yarn install

# Copy the transpiled JS code from the previous step
COPY --from=builder /usr/app/dist ./dist

# Copy config in as well
COPY .env ./dist

WORKDIR /usr/app/dist

# Set the NODE_ENV environmental variable to production
#ENV NODE_ENV="production"

EXPOSE 5000

CMD [ "node" ,"index.js"]