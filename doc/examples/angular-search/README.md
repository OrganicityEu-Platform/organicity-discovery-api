Discovery Incremental Search
----------------------------

By using the Asset Discovery Incremental Search method we can quickly search an asset by providing keywords incrementally. The following request method allows to filter the assets by matching keywords that are contained within the assets metadata:

```GET http://discovery.organicity.eu/v0/assets/metadata/search?query=some+text```

This allows to quickly build search and filter functionalities with modern front-end libraries as **Angular JS** and **Angular Material**. By combining the API request with an pre existing UI module as `md-autocomplete` we can create a basic search engine for any assets collection easily. 

[Demo](http://codepen.io/pral2a/pen/ALxAOp) 