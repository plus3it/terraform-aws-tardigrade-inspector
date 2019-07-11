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
			// see if a prereq directory exists
			if _, err := os.Stat(f.Name() + "/prereq/"); err == nil {
				directory := f.Name() + "/prereq/"
				// create the resources but don't destroy it. Let the overarching test take care of that
				runTerraform(t, directory, false)
			}

			// run terraform code
			runTerraform(t, f.Name(), true)
		}
	}
}

// The prequisite function runs the terraform code but doesn't destroy it afterwards so that the state can be used for further testing
func runTerraform(t *testing.T, directory string, destroyInfra bool) {
	terraformOptions := &terraform.Options{
		TerraformDir: directory,
		NoColor:      true,
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	if destroyInfra {
		defer terraform.Destroy(t, terraformOptions)
	}

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)
}
