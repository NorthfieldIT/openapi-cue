package main

import (
	"fmt"
	"os"

	"github.com/NorthfieldIT/openapi-cue/openapi"
	"github.com/ghodss/yaml"
)

func main() {

	b, err := openapi.Generate("sample.cue", &openapi.Info{
		Title:   "Sample Configuration",
		Version: "1.0.0",
		Desc:    "Start with the top level, Sample schema.",
	})

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
	writeFile(y, "public/sample.yaml")

}

func writeFile(contents []byte, path string) {
	err := os.WriteFile(path, contents, 0644)
	if err != nil {
		fmt.Print(err)
	}
}
