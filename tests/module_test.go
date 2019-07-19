package testing

import (
	"io/ioutil"
	"log"
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestModule(t *testing.T) {
	files, err := ioutil.ReadDir("./")

	if err != nil {
		log.Fatal(err)
	}

	for _, f := range files {
		// look for directories with test cases in it
		if f.IsDir() && f.Name() != "vendor" {
			investigateDirectory(t, f)
		}
	}
}

func investigateDirectory(t *testing.T, directory os.FileInfo) {
	// check if a prereq directory exists
	if _, err := os.Stat(directory.Name() + "/prereq/"); err == nil {
		prereqDir := directory.Name() + "/prereq/"
		prereqOptions := createTerraformOptions(prereqDir)
		defer terraform.Destroy(t, prereqOptions)
		runTerraform(t, prereqOptions, false)
	}

	// run terraform code for test case
	terraformOptions := createTerraformOptions(directory.Name())
	runTerraform(t, terraformOptions, true)
}

func createTerraformOptions(directory string) *terraform.Options {
	terraformOptions := &terraform.Options{
		TerraformDir: directory,
		NoColor:      true,
	}

	return terraformOptions
}

func runTerraform(t *testing.T, options *terraform.Options, destroyInfra bool) {
	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	if destroyInfra {
		defer terraform.Destroy(t, options)
	}

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, options)
}
