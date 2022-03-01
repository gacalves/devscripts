#!/bin/bash

ikeyToFind=$1
if [ -z "$ikeyToFind" ]; then
    echo "specify the instrumentaiton key"
    exit
fi
echo "search for instrumentation key $1"

# this function search for the instrumentation key in a given subscription
function findIKeyInSubscription {
  echo "Switch to subscription $1"
  az account set --subscription $1

  # list all the Application Insights resources.
  # for each of them take an instrumentation key 
  # and compare with one you looking for
  az resource list \
    --namespace microsoft.insights --resource-type components --query [*].[id] --out tsv \
      | while \
          read ID; \
          do  printf "$ID " && \
              az resource show --id "$ID" --query properties.InstrumentationKey --output tsv; \
        done \
      | grep "$ikeyToFind"
}

# run the search in every subscription...
az account list --query [*].[id] --out tsv \
    | while read OUT; do findIKeyInSubscription $OUT; done