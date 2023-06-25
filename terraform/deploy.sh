function deploy {
  TIMESTAMP=$(date +%Y%m%d%H%M%S)
  cd ../lambda/ && \
  npm i && \
  npm run build && \
  npm prune --production &&\
  mkdir dist &&\
  cp -r ./src/*.js dist/ &&\
  cp -r ./node_modules dist/ &&\
  cd dist &&\
  find . -name "*.zip" -type f -delete && \
  zip -r lambda_function_"$TIMESTAMP".zip . && \
  mv lambda_function_"$TIMESTAMP".zip ../../terraform/src/lambda_function_"$TIMESTAMP".zip && \
  cd .. && rm -rf dist &&\
  cd ../terraform && \
  terraform plan -input=false -var lambdasVersion="$TIMESTAMP" -out=./tfplan && \
  terraform apply -input=false ./tfplan
}

deploy
