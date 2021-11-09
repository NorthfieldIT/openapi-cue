#service: {
  name: =~"^[a-z]+$"
  hostname_reg: string
  backend: #backend & {}
  rules: [...#rules & {}]
}

// the backend is...
#backend: {
  // The host is
  host: int
  // Port of where host is listening
  port: int
  // Currently ELB or empty
  type: "" | "ELB"
}

#cache: {
  mode: "pass" | "static"
}

#fallback: {
  mode: "static" | "dynamic"
  status: int
}

#rules: {
  name: string
  path_regex: string
  method: "GET" | "PUT" | "POST" | "OPTIONS"
  cache: #cache
  fallback?: #fallback & {}
}