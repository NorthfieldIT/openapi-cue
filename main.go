package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"os"

	"cuelang.org/go/cue"
	"cuelang.org/go/cue/ast"
	"cuelang.org/go/cue/load"
	"cuelang.org/go/encoding/openapi"
	"github.com/ghodss/yaml"
)

func main() {

	b, err := genOpenAPI("service.cue", nil)
	if err != nil {
		fmt.Print(err)
	}
	//fmt.Println(string(b))

	writeFile(b, "openapi.json")

	y, err := yaml.JSONToYAML(b)
	if err != nil {
		fmt.Print(err)
	}

	fmt.Printf("\n%v", string(y))
	writeFile(y, "openapi.yaml")

}

func genOpenAPI(defFile string, config *load.Config) ([]byte, error) {
	buildInstances := load.Instances([]string{defFile}, config)
	insts := cue.Build(buildInstances)

	//openapi config, not a load config
	c := &openapi.Config{
		Info: ast.NewStruct(
			"title", ast.NewString("Connected Ship Configuration"),
			"version", ast.NewString("1.0.0"),
			"description", ast.NewString("Start with the service schema"),
		),
	}
	b, err := openapi.Gen(insts[0], c)
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

func writeFile(contents []byte, path string) {
	err := os.WriteFile(path, contents, 0644)
	if err != nil {
		fmt.Print(err)
	}
}
