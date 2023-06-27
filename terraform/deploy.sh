function deploy {
  # Generate a version number based on a date timestamp so that it's unique
  TIMESTAMP=$(date +%Y%m%d%H%M%S)
  cd ../lambda/ && \
  # Run the npm commands to transpile the TypeScript to JavaScript
  npm i && \
  npm run build && \
  npm prune --production &&\
  # Create a dist folder and copy only the js files to dist.
  # AWS Lambda does not have a use for a package.json or typescript files on runtime.
  mkdir dist &&\
  cp -r ./src/*.js dist/ &&\
  cp -r ./node_modules dist/ &&\
  cd dist &&\
  find . -name "*.zip" -type f -delete && \
  # Zip everything in the dist folder and
  zip -r ../../terraform/zips/lambda_function_"$TIMESTAMP".zip . && \
  cd .. && rm -rf dist &&\
  cd ../terraform && \
  terraform plan -input=false -var lambdasVersion="$TIMESTAMP" -out=./tfplan && \
  terraform apply -input=false ./tfplan
}

deploy
