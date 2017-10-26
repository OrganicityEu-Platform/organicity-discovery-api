Assets Discovery Service
------------------------------

The Asset Discovery API facilitates exploration and inspection of available assets.

## General Information

This API aims to create the foundations for a novel urban data observatory in the form of a service that allow various stakeholders (data scientists, city decision makers, organisations and citizens) to explore, with the intent to act, mixed static and real-time urban and social data streams and their exploitation in experimentation.

It comprises the following functionalities:

- Searching and filtering assets using multiple options
- Retrieving information about: services, sites and providers
- Retrieving assets data
- Retrieving experiments and the associated assets
- Support for [GeoJSON](http://geojson.org)

*This API is the core engine of the [Organicity Urban Data Observatory](http://observatory.organicity.eu/) and it is designed following the [OASC](http://oascities.org/) principles, as an extension of the [NGSI 9/10](https://forge.fiware.org/plugins/mediawiki/wiki/fiware/index.php/FI-WARE_NGSI-10_Open_RESTful_API_Specification) standard, specially following the new [FIWARE-NGSI v2 Specification](http://telefonicaid.github.io/fiware-orion/api/v2/latest/)*

## Documentation

- Check the **documentation** folder *[doc](https://github.com/OrganicityEu/organicity-discovery-api/tree/master/doc)*

## Status

[![Code Climate](https://codeclimate.com/github/OrganicityEu/organicity-discovery-api/badges/gpa.svg)](https://codeclimate.com/github/OrganicityEu/organicity-discovery-api)

https://travis-ci.org/OrganicityEu/organicity-discovery-api.svg?branch=master

## Testing

Currently we have only a handful of tests but you can run them through docker with:

`docker-compose exec app rake test --verbose`
