#service: {
name: =~"^[a-z]+$"
hostname_reg: string
backend: #Backend_type & {}
rules: [...#Rules_type & {}]
}

#Backend_type: {
host: int
port: int
type: string
}

#Cache_type: {
// @Summary this is a short summary
// The rest of the comment block is the description
// blah blah1    
mode: "pass" | "static"
}

#Fallback_type: {
mode: "static" | "dynamic"
status: int
}

#Rules_type: {
name: string
path_regex: string
method: "GET" | "PUT" | "POST" | "OPTIONS"
cache: #Cache_type
fallback?: #Fallback_type & {}
}
