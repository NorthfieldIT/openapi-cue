package openapi

import (
	"bytes"
	"encoding/json"

	"cuelang.org/go/cue"
	"cuelang.org/go/cue/ast"
	"cuelang.org/go/cue/load"
	"cuelang.org/go/encoding/openapi"
)

// Info when provided, is used to fill in the OpenAPI Info field
type Info struct {
	Title   string
	Version string
	Desc    string
}

// Generate generates an OpenAPI spec based on the CUE definition
func Generate(defFile string, info *Info) ([]byte, error) {
	buildInstances := load.Instances([]string{defFile}, nil)
	insts := cue.Build(buildInstances)

	//openapi config, not a load config
	var c openapi.Config
	if info != nil {
		c = openapi.Config{
			Info: ast.NewStruct(
				"title", ast.NewString(info.Title),
				"version", ast.NewString(info.Version),
				"description", ast.NewString(info.Desc),
			),
		}
	}

	b, err := openapi.Gen(insts[0], &c)
	if err != nil {
		return nil, err
	}

	var out bytes.Buffer
	err = json.Indent(&out, b, "", "  ")
	if err != nil {
		return nil, err
	}

	return out.Bytes(), nil
}
