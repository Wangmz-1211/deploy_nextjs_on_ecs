# Build Image
FROM node:21-alpine AS BUILD_IMAGE
WORKDIR /app
COPY .  .
RUN npm install --save-dev  && npm run build
RUN rm -rf node_modules
RUN npm install --save

# Production Image
FROM node:21-alpine
LABEL author="wangmz"
LABEL email="wangmz1211@icloud.com"
WORKDIR /app
COPY --from=BUILD_IMAGE ./app .
EXPOSE 3000
ENTRYPOINT [ "/usr/local/bin/npm", "run" ,"start" ]