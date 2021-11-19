package openapi

import (
	"bytes"
	"encoding/json"
	"fmt"
	"os"
	"testing"

	"github.com/PaesslerAG/jsonpath"
)

var cueFile = "test.cue"

func TestGenerate(t *testing.T) {
	t.Cleanup(cleanup)

	contents := bytes.NewBufferString(`#Identity: {
		// name of entity
		name: =~ "[A-Z].*"
	}
	`)
	writeFile(contents, cueFile)

	b, _ := Generate(cueFile, nil)
	//fmt.Print(string(b))

	var dat map[string]interface{}
	if err := json.Unmarshal(b, &dat); err != nil {
		panic(err)
	}

	got, err := jsonpath.Get("$.components.schemas.Identity.properties.name.description", dat)
	if err != nil {
		t.Fatal(err)
	}

	if got != "name of entity" {
		t.Errorf("Identity.name.description = %s; want 'name of entity'", got)
	}
}

func writeFile(contents *bytes.Buffer, path string) {
	err := os.WriteFile(path, contents.Bytes(), 0644)
	if err != nil {
		fmt.Print(err)
	}
}

func cleanup() {
	// how do we bubble errors to t.Fail or t.Fatal? Use t.TempDir instead?
	os.Remove(cueFile)
}
