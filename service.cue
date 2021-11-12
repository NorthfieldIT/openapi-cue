// ### To configure Connected Ship, fill in all required fields.
#Service: close({
    // The name of the service. This must be the same as the yml filename - why would you want it to not match? Are you some kind of animal?
    name: =~"^[a-z]+$"
    // Priority controls the ordering of the host header matching. Only applicable if you have multiple services. Lower numbers get rendered first.
    priority: <100
    // Regex of host header values that will be routed to this service
    hostname_regex: string
    // Paths to suppress logs, such as for healthchecks or monitoring. Multiple values accepted
    suppress_log: [...string]
    enable_503_troubleshooting_ui?: bool
    // ### Defines the [backend](https://varnish-cache.org/docs/trunk/users-guide/vcl-backends.html) for this service. A backend server is the server providing the content Gateway proxies.
    backend: #Backend
    // ### Here we define the 'rules' - routed by request url path.
    // ### Rules get processed from top to bottom and the first match wins.
    // ### Recommended to have the most specific rules at the top
    rules: {
        [...#Rule & {}]
    }
    // ### TODO
    snippets?: {
        [...#Snippet & {}]
    }
})

#Backend: {
    // Hostname or IP - this must be resolvable when Varnish boots up or it will crash
    host: string
    port: uint
    type?: string
    first_byte_timeout?: =~"^\\d+[s,m]$"
    connect_timeout?: =~"^\\d+[s,m]$"
    between_bytes_timeout?: =~"^\\d+[s,m]$"
    // ### Probe configures the health check of this backend by periodically sending a request to test if the backend is answering and thus "healthy".
    probe: {
        // What URL should varnish request (/health).
        url: string
        // What is the timeout of the probe
        timeout: =~"^\\d+[s,m]$"
        // How often should we poll
        interval: =~"^\\d+[s,m]$"
        // The number of probe results in the sliding window
        window: uint
        // How many of the of the probes a good when Gateway starts.
        initial: uint
        expected_response: uint
        // How many of the .window last polls must be good for the backend to be declared healthy.
        threshold: int
    }
}

#Method: { "GET" | "POST" | "OPTIONS" | "PUT" | "DELETE" | "HEAD" }

#Rule: {
    // An identifier and short description
    name: string
    // How the rule is triggered
    path_regex: string
    // method should match an HTTP method
    method: #Method 
    // if defined, "all" strips all cookies
    cookies?: {
      strip?: "all" 
    }
    // ### Tags that will be logged with all requests that hit this rule
    // ### Tags are logged as key value pairs in the following format:
    // `key1:val1,key2:val2`
    // ### Colons (:) and commas (,) are reserved characters that will be removed prior to logging
    tags?: {...}
    // Vary the cache on the sum of the value of these headers.
    vary?: [...]
    // ### TODO
    auth?: {...}
    // ### How or if objects matching the `path_regex` should be cached. Objects within the time-to-live (TTL) are considered fresh objects. Stale objects are those within the time period TTL and grace.
    cache?: {
        // Modes are:
        // * pass: do not cache this `path_regex`; creates a hit-for-pass
        // * static: Cacheable - static TTL via config but overridable by origin
        // * override: Cacheable - static TTL via config and overrides origin
        // * origin: Cacheable - respect origin TTL and Grace 
        // ** ex. Cache-Control: max-age=60, stale-while-revalidate=86400
        // ** `TTL` is controlled by max-age etc, `grace` is controlled by stale-while-revalidate
        mode: "pass" | "static" | "override" | "origin"
        // An object lives in cache until TTL + grace elapses
        ttl?: =~"^\\d+[s,m]$"
        // Serve content that is somewhat [stale](https://varnish-cache.org/docs/trunk/users-guide/vcl-grace.html) instead of waiting for a fresh object from the backend.
        grace?: =~"^\\d+[s,m]$"
    }

    fallback: {
        headers?: {...}
        ...
    }

}

#Snippet: {
    name: string
    sub: "recv" | "deliver" | "backend_fetch"
    vcl: string
}
