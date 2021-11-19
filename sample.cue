// ### To configure Sample, fill in all required fields.
#Sample: {
    // The name of the service. This must be the same as the yml filename - why would you want it to not match? Are you some kind of animal?
    name: =~"^[a-z]+$"
    // Priority controls the ordering of the host header matching. Only applicable if you have multiple services. Lower numbers get rendered first.
    priority: <100
    // Regex of host header values that will be routed to this service
    hostname_regex: string
    // ### Here we define the 'rules' - routed by request url path.
    rules: {
        [...#Rule & {}]
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
}
