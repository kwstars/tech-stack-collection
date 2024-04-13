HTTP Range Requests 是一种允许客户端请求资源的一部分，而不是整个资源的 HTTP 功能。这种功能在处理大文件或者流媒体内容时特别有用。以下是一些关于 HTTP Range Requests 的关键知识点：

1. **Range Headers**：客户端可以通过在 HTTP 请求中包含 `Range` 头部来请求资源的一部分。例如，`Range: bytes=0-499` 表示请求资源的前 500 个字节。

2. **Partial Content Response**：如果服务器支持 Range Requests，并且请求的范围有效，服务器会返回状态码 `206 Partial Content`，并在响应体中包含请求的资源部分。

3. **Content-Range Headers**：在返回部分内容的响应中，服务器会包含 `Content-Range` 头部来指示返回的资源部分在整个资源中的位置。例如，`Content-Range: bytes 0-499/1234` 表示整个资源大小为 1234 字节，返回的是前 500 个字节。

4. **Multiple Ranges**：客户端可以在一个请求中请求多个范围，但是服务器不一定支持这种请求。如果服务器支持，它会返回一个 `multipart/byteranges` 响应。

5. **If-Range Headers**：客户端可以使用 `If-Range` 头部来只在资源没有改变时请求部分内容。如果资源已经改变，服务器会返回整个资源。

6. **Accept-Ranges Headers**：服务器可以通过 `Accept-Ranges` 头部来指示它是否支持 Range Requests。如果服务器支持，它会包含 `Accept-Ranges: bytes` 头部。如果不支持，它会包含 `Accept-Ranges: none` 头部。

7. **Byte Serving**：支持 Range Requests 的服务器通常被称为 "byte-serving" 服务器。

这些知识点可以帮助你理解和使用 HTTP Range Requests，以更有效地处理大文件和流媒体内容。
