## Basic Rules
```
OCTET          = <any 8-bit sequence of data>
CHAR           = <any US-ASCII character (octets 0 - 127)>
UPALPHA        = <any US-ASCII uppercase letter "A".."Z">
LOALPHA        = <any US-ASCII lowercase letter "a".."z">
ALPHA          = UPALPHA | LOALPHA
DIGIT          = <any US-ASCII digit "0".."9">
CTL            = <any US-ASCII control character
                (octets 0 - 31) and DEL (127)>
CR             = <US-ASCII CR, carriage return (13)>
LF             = <US-ASCII LF, linefeed (10)>
SP             = <US-ASCII SP, space (32)>
HT             = <US-ASCII HT, horizontal-tab (9)>
<">            = <US-ASCII double-quote mark (34)>
```

HTTP/1.1 defines the sequence CR LF as `the end-of-line` marker for all protocol elements except the entity-body
## entidy-body semantically defintion
### The end-of-line marker within an entity-body （entity-body 开始位置）
```
CRLF           = CR LF
```

### HTTP/1.1 header field values can be folded onto multiple lines if the continuation line begins with a space or horizontal tab
```
LWS            = [CRLF] 1*( SP | HT )
```
###  The TEXT rule is only used for descriptive field contents and values（kv 语法）
```
TEXT           = <any OCTET except CTLs,but including LWS>
```
A CRLF is allowed in the definition of TEXT only as part of a header field continuation. It is expected that the folding LWS will be replaced with a single SP before interpretation of the TEXT value.

### hexadecimal(十六进制)
```
HEX            = "A" | "B" | "C" | "D" | "E" | "F"
                | "a" | "b" | "c" | "d" | "e" | "f" | DIGIT
```

### These special characters consis of HTTP/1.1 header field values（可以包含在kv的特色字符）
> Many HTTP/1.1 header field values consist of words separated by LWS or special characters. These special characters MUST be in a quoted string to be used within a parameter value
```
token          = 1*<any CHAR except CTLs or separators>
separators     = "(" | ")" | "<" | ">" | "@"
                      | "," | ";" | ":" | "\" | <">
                      | "/" | "[" | "]" | "?" | "="
                      | "{" | "}" | SP | HT
```
### 头部字段注释语法
```
comment        = "(" *( ctext | quoted-pair | comment ) ")ctext          = <any TEXT excluding "(" and ")">
```
### 双引号包裹字符串可作为单独词
```
quoted-string  = ( <"> *(qdtext | quoted-pair ) <"> )
qdtext         = <any TEXT except <">>
quoted-pair    = "\" CHAR
```

## Protocol Paramenters

### HTTP Version
```
HTTP-Version   = "HTTP" "/" 1*DIGIT "." 1*DIGIT
```
### Uniform Resource Identifiers
```
http_URL = "http:" "//" host [ ":" port ] [ abs_path [ "?" query ]]
```
### Date/Time Formats
- Full Date
  ```
    HTTP-date    = rfc1123-date | rfc850-date | asctime-date
    rfc1123-date = wkday "," SP date1 SP time SP "GMT"
    rfc850-date  = weekday "," SP date2 SP time SP "GMT"
    asctime-date = wkday SP date3 SP time SP 4DIGIT
    date1        = 2DIGIT SP month SP 4DIGIT
                    ; day month year (e.g., 02 Jun 1982)
    date2        = 2DIGIT "-" month "-" 2DIGIT
                    ; day-month-year (e.g., 02-Jun-82)
    date3        = month SP ( 2DIGIT | ( SP 1DIGIT ))
                    ; month day (e.g., Jun  2)
    time         = 2DIGIT ":" 2DIGIT ":" 2DIGIT
                    ; 00:00:00 - 23:59:59
    wkday        = "Mon" | "Tue" | "Wed"
                    | "Thu" | "Fri" | "Sat" | "Sun"
    weekday      = "Monday" | "Tuesday" | "Wednesday"
                    | "Thursday" | "Friday" | "Saturday" | "Sunday"
    month        = "Jan" | "Feb" | "Mar" | "Apr"
                    | "May" | "Jun" | "Jul" | "Aug"
                    | "Sep" | "Oct" | "Nov" | "Dec"
  ```
- Delta Seconds
  ```
    delta-seconds  = 1*DIGIT
  ```
### Character Sets
```
charset     = token
```

#### Transfer Codings
```
transfer-coding         = "chunked" | transfer-extension
transfer-extension      = token *( ";" parameter )
parameter               = attribute "=" value
attribute               = token
value                   = token | quoted-string
```
#### Chunked Transfer Coding
```
Chunked-Body   = *chunk
                last-chunk
                trailer
                CRLF

chunk          = chunk-size [ chunk-extension ] CRLF
                chunk-data CRLF
chunk-size     = 1*HEX
last-chunk     = 1*("0") [ chunk-extension ] CRLF

chunk-extension= *( ";" chunk-ext-name [ "=" chunk-ext-val ] )
chunk-ext-name = token
chunk-ext-val  = token | quoted-string
chunk-data     = chunk-size(OCTET)
trailer        = *(entity-header CRLF)
```
### Media Types in the Content-Type
```
media-type     = type "/" subtype *( ";" parameter )
type           = token
subtype        = token
```
### Product Tokens
```
product         = token ["/" product-version]
product-version = token
```

### Quality Values-floating point
0 is the minimum and 1 the maximum
```
qvalue         = ( "0" [ "." 0*3DIGIT ] )
                | ( "1" [ "." 0*3("0") ] )
```
### Language Tags
```
language-tag  = primary-tag *( "-" subtag )
primary-tag   = 1*8ALPHA
subtag        = 1*8ALPHA
```
### Entity Tags
HTTP/1.1 uses entity tags in the ETag, If-Match, If-None-Match, and If-Range header fields.
The definition of how they are used and compared as cache validators
```
entity-tag = [ weak ] opaque-tag
weak       = "W/"
opaque-tag = quoted-string
```
### Range Units
```
range-unit       = bytes-unit | other-range-unit
bytes-unit       = "bytes"
other-range-unit = token

```

## HTTP Message
### Message
```
HTTP-message    = Request | Response     ; HTTP/1.1 messages
#the format for Request message or Response message
generic-message = start-line
                *(message-header CRLF)
                CRLF
                [ message-body ]
message-body    = entity-body
                    | <entity-body encoded as per Transfer-Encoding>
message-header  = field-name ":" [ field-value ]
field-name      = token
field-value     = *( field-content | LWS )
field-content   = <the OCTETs making up the field-value 
                and consisting of either *TEXT or combinations of token, separators, and quoted-string>
start-line      = Request-Line | Status-Line
```
### Message Length

### General Header Fields
```
general-header = Cache-Control            ; Section 14.9
                | Connection               ; Section 14.10
                | Date                     ; Section 14.18
                | Pragma                   ; Section 14.32
                | Trailer                  ; Section 14.40
                | Transfer-Encoding        ; Section 14.41
                | Upgrade                  ; Section 14.42
                | Via                      ; Section 14.45
                | Warning                  ; Section 14.46
```
## Request message
```
Request       = Request-Line              ; Section 5.1
                *(( general-header        ; Section 4.5
                 | request-header         ; Section 5.3
                 | entity-header ) CRLF)  ; Section 7.1
                CRLF
                [ message-body ]  
```
### Request-Line
```
Request-Line   = Method SP Request-URI SP HTTP-Version CRLF
```
#### Method
```
Method         = "OPTIONS"                ; Section 9.2
                | "GET"                    ; Section 9.3
                | "HEAD"                   ; Section 9.4
                | "POST"                   ; Section 9.5
                | "PUT"                    ; Section 9.6
                | "DELETE"                 ; Section 9.7
                | "TRACE"                  ; Section 9.8
                | "CONNECT"                ; Section 9.9
                | extension-method
extension-method = token
```
#### Request-URI
```
Request-URI    = "*" | absoluteURI | abs_path | authority
```
- An '*' example
The asterisk "*" means that the request does not apply to a particular resource, but to the server itself, and is only allowed when the method used does not necessarily apply to a resource. One example would be
```
 OPTIONS * HTTP/1.1
```
- An absoluteURI example
  ```
  GET http://www.w3.org/pub/WWW/TheProject.html HTTP/1.1
  ```
- An abs_path example
  the most common form of Request-URI
  ```
   GET /pub/WWW/TheProject.html HTTP/1.1
   Host: www.w3.org
  ```
- authority
  The authority form is only used by the CONNECT method

### The Resource Identified by a Request
- If Request-URI is an absoluteURI the host is part of the Request-URI. Any Host header field value in the request MUST be ignored.
- If the Request-URI is not an absoluteURI, and the request includes a Host header field, the host is determined by the Host header field value.
- If the host as determined by rule 1 or 2 is not a valid host on the server, the response MUST be a 400 (Bad Request) error message.

### Request Header Fields
```
request-header = Accept                   ; Section 14.1
                | Accept-Charset           ; Section 14.2
                | Accept-Encoding          ; Section 14.3
                | Accept-Language          ; Section 14.4
                | Authorization            ; Section 14.8
                | Expect                   ; Section 14.20
                | From                     ; Section 14.22
                | Host                     ; Section 14.23
                | If-Match                 ; Section 14.24
                | If-Modified-Since        ; Section 14.25
                | If-None-Match            ; Section 14.26
                | If-Range                 ; Section 14.27
                | If-Unmodified-Since      ; Section 14.28
                | Max-Forwards             ; Section 14.31
                | Proxy-Authorization      ; Section 14.34
                | Range                    ; Section 14.35
                | Referer                  ; Section 14.36
                | TE                       ; Section 14.39
                | User-Agent               ; Section 14.43
```

## Response
```
Response      = Status-Line               ; Section 6.1
               *(( general-header        ; Section 4.5
                | response-header        ; Section 6.2
                | entity-header ) CRLF)  ; Section 7.1
               CRLF
               [ message-body ]          ; Section 7.2
```
### Status-Line
```
Status-Line = HTTP-Version SP Status-Code SP Reason-Phrase CRLF
```
#### Status-Code and Reason Phrase
The Status-Code element is a 3-digit integer result code of the attempt to understand and satisfy the request.
The Reason-Phrase is intended to give a short textual description of the Status-Code.
```
Status-Code ：Reason Phrase
Status-Code    = "100"  ; Section 10.1.1: Continue
                | "101"  ; Section 10.1.2: Switching Protocols
                | "200"  ; Section 10.2.1: OK
                | "201"  ; Section 10.2.2: Created
                | "202"  ; Section 10.2.3: Accepted
                | "203"  ; Section 10.2.4: Non-Authoritative Information
                | "204"  ; Section 10.2.5: No Content
                | "205"  ; Section 10.2.6: Reset Content
                | "206"  ; Section 10.2.7: Partial Content
                | "300"  ; Section 10.3.1: Multiple Choices
                | "301"  ; Section 10.3.2: Moved Permanently
                | "302"  ; Section 10.3.3: Found
                | "303"  ; Section 10.3.4: See Other
                | "304"  ; Section 10.3.5: Not Modified
                | "305"  ; Section 10.3.6: Use Proxy
                | "307"  ; Section 10.3.8: Temporary Redirect
                | "400"  ; Section 10.4.1: Bad Request
                | "401"  ; Section 10.4.2: Unauthorized
                | "402"  ; Section 10.4.3: Payment Required
                | "403"  ; Section 10.4.4: Forbidden
                | "404"  ; Section 10.4.5: Not Found
                | "405"  ; Section 10.4.6: Method Not Allowed
                | "406"  ; Section 10.4.7: Not Acceptable
                | "407"  ; Section 10.4.8: Proxy Authentication Required
                | "408"  ; Section 10.4.9: Request Time-out
                | "409"  ; Section 10.4.10: Conflict
                | "410"  ; Section 10.4.11: Gone
                | "411"  ; Section 10.4.12: Length Required
                | "412"  ; Section 10.4.13: Precondition Failed
                | "413"  ; Section 10.4.14: Request Entity Too Large
                | "414"  ; Section 10.4.15: Request-URI Too Large
                | "415"  ; Section 10.4.16: Unsupported Media Type
                | "416"  ; Section 10.4.17: Requested range not satisfiable
                | "417"  ; Section 10.4.18: Expectation Failed
                | "500"  ; Section 10.5.1: Internal Server Error
                | "501"  ; Section 10.5.2: Not Implemented
                | "502"  ; Section 10.5.3: Bad Gateway
                | "503"  ; Section 10.5.4: Service Unavailable
                | "504"  ; Section 10.5.5: Gateway Time-out
                | "505"  ; Section 10.5.6: HTTP Version not supported
                | extension-code

extension-code = 3DIGIT
Reason-Phrase  = *<TEXT, excluding CR, LF>
```
The first digit of the Status-Code defines the class of response. but not MUST

- 1xx: Informational - Request received, continuing process

- 2xx: Success - The action was successfully received,
  understood, and accepted

- 3xx: Redirection - Further action must be taken in order to
  complete the request

- 4xx: Client Error - The request contains bad syntax or cannot
  be fulfilled

- 5xx: Server Error - The server failed to fulfill an apparently
  valid request

### Response Header Fields
```
response-header = Accept-Ranges           ; Section 14.5
                | Age                     ; Section 14.6
                | ETag                    ; Section 14.19
                | Location                ; Section 14.30
                | Proxy-Authenticate      ; Section 14.33
                | Retry-After             ; Section 14.37
                | Server                  ; Section 14.38
                | Vary                    ; Section 14.44
                | WWW-Authenticate        ; Section 14.47

```

## Entity
Request and Response messages MAY transfer an entity if not otherwise restricted by the request method or response status code.
**An entity consists of entity-header fields and an entity-body, although some responses will only include the entity-headers.**
`用于接受或者请求要求控制条目,对信息本身处理指导`
### Entity Header Fields
```
entity-header  = Allow                    ; Section 14.7
               | Content-Encoding         ; Section 14.11
               | Content-Language         ; Section 14.12
               | Content-Length           ; Section 14.13
               | Content-Location         ; Section 14.14
               | Content-MD5              ; Section 14.15
               | Content-Range            ; Section 14.16
               | Content-Type             ; Section 14.17
               | Expires                  ; Section 14.21
               | Last-Modified            ; Section 14.29
               | extension-header

extension-header = message-header

```
### Entity Body
The entity-body (if any) sent with an HTTP request or response is in a format and encoding defined by the entity-header fields.
```
entity-body    = *OCTET
```
### Type
```
entity-body := Content-Encoding( Content-Type( data ) )
```
### Entity Length

## Connections
### Persistent Connections
#### Purpose
#### Overall Operation
#### Negotiation
#### Pipelining
#### Proxy Servers
#### Practical Considerations

### Message Transmission Requirements
#### Persistent Connections and Flow Control
#### Monitoring Connections for Error Status Messages
#### Use of the 100 (Continue) Status
- Requirements for HTTP/1.1 clients
- Requirements for HTTP/1.1 origin servers
- Requirements for HTTP/1.1 proxies:

#### Client Behavior if Server Prematurely Closes Connection
- when Client Behavior if Server Prematurely Closes Connection
  1. an HTTP/1.1 client sends a request which includes a request body,
   but which does not include an Expect request-header field with the
   "100-continue" expectation
  2. the client is not directly connected to an HTTP/1.1 origin server
  3. the client sees the connection close before receiving any status from the server
   
- the client do retry connection following "binary exponential backoff" algorithm
  1. Initiate a new connection to the server

  2. Transmit the request-headers

  3. Initialize a variable R to the estimated round-trip time to the server (e.g., based on the time it took to establish the connection), or to a constant value of 5 seconds if the round-trip time is not available.

  4. Compute T = R * (2**N), where N is the number of previous retries of this request.
  
  5. Wait either for an error response from the server, or for T seconds (whichever comes first)

  6. If no error response is received, after T seconds transmit the body of the request.

  7. If client sees that the connection is closed prematurely, repeat from step 1 until the request is accepted, an error response is received, or the user becomes impatient and terminates the retry process.
- if at any point an error status is received when retry connection,the client
  1. SHOULD NOT continue and
  2. SHOULD close the connection if it has not completed sending the request message.

## Method Definitions
### Safe and Idempotent Methods
#### Safe Methods
- safe methods 
  - GET
  - HEAD
- unsafe methods
  - POST
  - PUT
  - DELETE

#### Idempotent Methods(幂等方法)
### OPTIONS
### GET
### HEAD
### POST
### PUT
### TRACE
The TRACE method is used to invoke a remote, application-layer loop-back of the request message.
The final recipient of the request SHOULD reflect the message received back to the client as the entity-body of a 200 (OK) response
The final recipient is either the origin server or the first proxy or gateway to receive a Max-Forwards value of zero (0) in the request

A TRACE request MUST NOT include an entity.
#### Using
TRACE allows the client to see what is being received at the other end of the request chain and use that data for testing or diagnostic information.
the **Max-Forwards** header field allows the client to limit the length of the request chain
#### Response
- SHOULD contain the entire request message in the entity-body,with a Content-Type of "message/http"
- MUST NOT be cached

### CONNECT
the CONNECT method for use with a proxy that can dynamically switch to being a tunnel

## Status Code Definitions
### Informational 1xx
#### 100 Continue
#### 101 Switching Protocols

### Successfull 2xx
#### 200 Ok
#### 201 Created
#### 202 Accepted
#### 203 Non-Authorizative Information
#### 204 No Content
#### 205 Reset Content
#### 206 Pratial Content

### Redirection 3xx
#### 300 Multiple Choices
#### 301 Moved Permanently
#### 302 Found
#### 303 See Other
#### 304 Not Modified
#### 305 Use Proxy
#### 306 (Unused)
#### 307 Temporary Redirect

### Client Error 4xx
#### 400 Bad Request
#### 401 Unauthorized 
#### 402 Payment Required
#### 403 Forbidden
#### 404 Not Found
#### 405 Method Not Allowd
#### 406 Not Acceptable
#### 407 Proxy Authorization Required
#### 408 Request Timeout
#### 409 Conflict
#### 410 Gone
#### 411 Length Required
#### 412 Precondition Failed
#### 413 Request Entity Too larage
#### 414 Request-URI Too long
#### 415 Unsupported Media Type
#### 416 Requested Range Not Satisfiable
#### 417 Expectation Failed

### Server Error 5xx
#### 500 Internal Server Error
#### 501 Not Implemented
#### 502 Bad Gateway
#### 503 Service Unavailable
#### 504 Gateway Timeout
#### 505 HTTP Version Not Supported

## Access Authentication
## Content Negotiation
### Server-driven Negotiation
### Agent-driven Negotiation
### Transparent Negotiation

## Caching in HTTP
### Cache Correctness
### Warnings
### Cache-control Mechanisms
###

## Header Field Definitions
### Accept
```
Accept         = "Accept" ":"
                #( media-range [ accept-params ] )

media-range    = ( "*/*"
                | ( type "/" "*" )
                | ( type "/" subtype )
                ) *( ";" parameter )
accept-params  = ";" "q" "=" qvalue *( accept-extension )
accept-extension = ";" token [ "=" ( token | quoted-string ) ]
```
### Accept-Charset
```
Accept-Charset = "Accept-Charset" ":"
              1#( ( charset | "*" )[ ";" "q" "=" qvalue ] )
```
### Accept-Encoding
```
Accept-Encoding  = "Accept-Encoding" ":"
                1#( codings [ ";" "q" "=" qvalue ] )
codings          = ( content-coding | "*" )

```
### Accept-Language
```
Accept-Language = "Accept-Language" ":"
                 1#( language-range [ ";" "q" "=" qvalue ] )
language-range  = ( ( 1*8ALPHA *( "-" 1*8ALPHA ) ) | "*" )
```
### Accept-Ranges
```
Accept-Ranges     = "Accept-Ranges" ":" acceptable-ranges
acceptable-ranges = 1#range-unit | "none"
```
### Age
```
Age = "Age" ":" age-value
age-value = delta-seconds
```
### Allow
```
Allow   = "Allow" ":" #Method
```
### Authorization
```
Authorization  = "Authorization" ":" credentials
```
### Cache-Control
```
Cache-Control   = "Cache-Control" ":" 1#cache-directive

cache-directive = cache-request-directive
                | cache-response-directive

cache-request-directive =
       "no-cache"                          ; Section 14.9.1
     | "no-store"                          ; Section 14.9.2
     | "max-age" "=" delta-seconds         ; Section 14.9.3, 14.9.4
     | "max-stale" [ "=" delta-seconds ]   ; Section 14.9.3
     | "min-fresh" "=" delta-seconds       ; Section 14.9.3
     | "no-transform"                      ; Section 14.9.5
     | "only-if-cached"                    ; Section 14.9.4
     | cache-extension                     ; Section 14.9.6

 cache-response-directive =
       "public"                               ; Section 14.9.1
     | "private" [ "=" <"> 1#field-name <"> ] ; Section 14.9.1
     | "no-cache" [ "=" <"> 1#field-name <"> ]; Section 14.9.1
     | "no-store"                             ; Section 14.9.2
     | "no-transform"                         ; Section 14.9.5
     | "must-revalidate"                      ; Section 14.9.4
     | "proxy-revalidate"                     ; Section 14.9.4
     | "max-age" "=" delta-seconds            ; Section 14.9.3
     | "s-maxage" "=" delta-seconds           ; Section 14.9.3
     | cache-extension                        ; Section 14.9.6

cache-extension = token [ "=" ( token | quoted-string ) ]
```
#### What is Cacheable
The following Cache-Control response directives allow an origin server to override the default cacheability of a response:
- public
- private
- no-cache

#### What May be Stored by Caches
- no-store

#### Modifications of the Basic Expiration Mechanism
- s-maxage
- max-age
- min-fresh
- max-stale
#### Cache Revalidation and Reload Controls

- End-to-end
- Specific end-to-end revalidation
- Unspecified end-to-end revalidation
- max-age
- only-if-cached
- must-revalidate
- proxy-revalidate

#### No-Transform Directive
no-transform

#### Cache Control Extensions
```
 Cache-Control: private, community="UCI"
```

### Connection
```
Connection = "Connection" ":" 1#(connection-token)
connection-token  = token
```
### Content-Encoding
```
Content-Encoding  = "Content-Encoding" ":" 1#content-coding
```
### Content-Language
```
Content-Language  = "Content-Language" ":" 1#language-tag
```
### Content-Length
```
Content-Length    = "Content-Length" ":" 1*DIGIT
```
### Content-Location
```
Content-Location = "Content-Location" ":"
                 ( absoluteURI | relativeURI )
```
### Content-MD5
```
Content-MD5   = "Content-MD5" ":" md5-digest
md5-digest   = <base64 of 128 bit MD5 digest as per RFC 1864>
```