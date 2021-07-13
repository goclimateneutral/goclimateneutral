# GoClimate API Reference

## Introduction

The GoClimate API is organized around [REST][rest]. It has
resource-oriented URLs, accepts form-encoded request bodies, returns
[JSON-encoded][json] responses, and uses standard HTTP response codes,
authentication, and verbs.

[rest]: https://developer.mozilla.org/en-US/docs/Glossary/REST
[json]: http://www.json.org/

## Calculation Model

The GoClimate API uses IATA-airport codes of a route to calculate the 
CO2-emissions. You can read more about how the 
calculation is done [here][pdf].

[pdf]: https://www.goclimate.com/blog/wp-content/uploads/2019/04/Calculations-in-GoClimateNeutral-Flight-Footprint-API.pdf

## Client libraries

We do not provide official client libraries. However, here's a list of
community libraries:

- [climate_neutral by codeboten](https://github.com/codeboten/climate_neutral) (Python)

## Authentication

The GoClimate API uses API keys to authenticate requests. Get your API
key by [requesting one][request].

Authentication to the API is performed via [HTTP Basic Auth][basic-auth].
Provide your API key as the basic auth username value and leave the password
empty. Authentication is required for all endpoints.

[request]: ./api_keys
[basic-auth]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Authentication

## Errors

GoClimate uses conventional HTTP status codes to indicate the success or
failure of API requests.

**Summary of HTTP status codes used by the GoClimate API:**

- **200 OK:** Request was successful.
- **404 Not Found:** The requested resource could not be found.
- **401 Unauthorized:** API key provided was not valid.
- **500, 502, 503, 504:** Server errors on the GoClimate side. Only used
  in exceptional circumstances.

## Resources

### Flight Footprint

Calculates estimated footprint per passenger for flights.

#### Retrieving flight footprint

Retrieve estimated footprint for one flight. If you need to calculate footprint
for a trip with multiple legs, retrieve the estimated footprint for each leg
and sum estimated footprint for each to create a total for the full trip.

**Endpoint:**

`GET /v1/flight_footprint`

**Request parameters:**

- Segments of the flight itenireary. For each parameter below, replace n with a unique identifier for each segment of the trip. These parameters are repeated for each segment.
  - **segments[n][origin]:** Origin airport IATA code.
  - **segments[n][destination]:** Destination airport IATA code.
- **cabin_class:** Cabin class. One of `economy`, `premium_economy`, `business`
  and `first`.
- **currencies[]:** Desired currencies for offset pricing. One of `EUR`, `USD`, `SEK` and `NOK`. You can request multiple currencies by including multiple items in the currencies array. You may also use an identifier for every currency (i.e `currencies[n]=NOK`).

**Response attributes:**

- **footprint**: Estimated footprint per passenger. In kgs CO2e.  Current
  precision is 100 kg. We recommend displaying this number in tonnes CO2e to the
  user.
- **offset_prices[]:** Array of objects representing prices per passenger for
  offsetting this flight through GoClimate. One object per currency
  requested.
  Currently returns non-final prices in SEK.
  - **amount**: Amount. In smallest denomination of currency indicated by
    **currency** (e.g. 1000 for 10.00 EUR).
  - **currency**: ISO 4217 currency code for amount specified by **amount**.
  - **offset\_url**: URL to a page where the user can offset the flight in **currency**.
  - **locale**: IETF BCP 47 formatted locale of the offset page.
- _(DEPRECATED) **details\_url**: URL to a page where the user can offset the flight. Use **offset\_prices[][offset\_url]** instead._

**Errors:**

- **invalid\_request\_error - HTTP status 400**: Request parameters are missing
  or not valid.
- **calculation_unsuccessful - HTTP status 404:** We are currently not able to
  calculate an estimated footprint based on the given parameters. This is not a
  permanent state as we continuously work to improve coverage, although
  immediate retries are not likely to produce a different result.

#### Example

Request:

    $ curl https://api.goclimate.com/v1/flight_footprint \
      -u YOUR_API_KEY: \
      -d 'segments[0][origin]=ARN' \
      -d 'segments[0][destination]=BCN' \
      -d 'segments[1][origin]=BCN' \
      -d 'segments[1][destination]=ARN' \
      -d 'cabin_class=economy' \
      -d 'currencies[]=SEK' \
      -d 'currencies[]=USD' \
      -G

Response:

    {
      "footprint": 1400,
      "offset_prices": [
        {
          "amount": 4000,
          "currency": "SEK"
          "offset_url":"https://www.goclimate.com/se/flight_offsets/new?offset_params=economy%2CARN%2CBCN%2CBCN%2CARN",
          "locale":"sv-SE"
        },
        {
          "amount":400,
          "currency":"USD",
          "offset_url":"https://www.goclimate.com/us/flight_offsets/new?offset_params=economy%2CARN%2CBCN%2CBCN%2CARN",
          "locale":"en-US"
        }
      ],
      "details_url": "https://www.goclimate.com/flight_offsets/new?offset_params=economy%2CARN%2CBCN%2CBCN%2CARN"
    }

