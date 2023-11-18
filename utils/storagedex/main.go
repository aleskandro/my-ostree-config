package main

import (
	"fmt"
	"os"
	"strings"

	"encoding/base32"
	"hash"
	"hash/fnv"

	"github.com/spf13/cobra"
	"gopkg.in/yaml.v3"
)

/*
References:
- https://github.com/dexidp/dex/blob/e41a28bf27225ab503eb9feef4feedd03bb4ac71/storage/kubernetes/client.go#L72-L78
- https://github.com/dexidp/dex/blob/e41a28bf27225ab503eb9feef4feedd03bb4ac71/storage/kubernetes/client.go#L427
*/

type ObjectMeta struct {
	Name      string `yaml:"name,omitempty"`
	Namespace string `yaml:"namespace,omitempty"`
}

type TypeMeta struct {
	APIVersion string `yaml:"apiVersion,omitempty"`
	Kind       string `yaml:"kind,omitempty"`
}

type Client struct {
	TypeMeta   `yaml:",inline"`
	ObjectMeta `yaml:"metadata,omitempty"`

	// ID is immutable, since it's a primary key and should not be changed.
	ID string `yaml:"ID"`

	Secret       string   `yaml:"Secret,omitempty"`
	RedirectURIs []string `yaml:"RedirectURIs,omitempty"`
	TrustedPeers []string `yaml:"TrustedPeers,omitempty"`

	Public bool `yaml:"Public"`

	Name    string `yaml:"Name,omitempty"`
	LogoURL string `yaml:"LogoURL,omitempty"`
}

var encoding = base32.NewEncoding("abcdefghijklmnopqrstuvwxyz234567")

func idToName(s string, h func() hash.Hash) string {
	return strings.TrimRight(encoding.EncodeToString(h().Sum([]byte(s))), "=")
}

func main() {
	var rootCmd = &cobra.Command{
		Use:   os.Args[0],
		Short: "Generate a Dex oauth2client Kubernetes object from the command line",
		Long: "Dex supports Kubernetes as a storage backend. However, users are not expected to " +
			"create the Kubernetes objects themselves. " +
			"They are expected to use the Dex API to manage the Dex state dynamically.\n" +
			"As that is not comfortable for the kustomization deployment of oauth2clients, this tool allows to " +
			"generate it from the command line. The specific issue of the needs for this is that the OAuth2Client " +
			"expected name is the base32 encoding of the FNV hash of the client ID.\n" +
			"This tool generattes a dex.coreos.com/v1 OAuth2Client object based on the input parameters.\n" +
			"The output is in YAML format, ready to be used in a kustomization.",
	}

	var client = Client{
		RedirectURIs: make([]string, 0),
		TrustedPeers: make([]string, 0),
		TypeMeta: TypeMeta{
			APIVersion: "dex.coreos.com/v1",
			Kind:       "OAuth2Client",
		},
		ObjectMeta: ObjectMeta{
			Namespace: "",
			Name:      "",
		},
	}
	rootCmd.PersistentFlags().StringVarP(&client.ID, "id", "i",
		"", "Client ID is the unique identifier for the client")
	rootCmd.PersistentFlags().StringVarP(&client.Secret, "secret", "s",
		"", "Client Secret is the secret for the client")
	rootCmd.PersistentFlags().StringSliceVarP(&client.RedirectURIs, "redirect-uris", "r",
		[]string{}, "Redirect URIs is the list of allowed redirect URLs for the client")
	rootCmd.PersistentFlags().StringSliceVarP(&client.TrustedPeers, "trusted-peers", "t",
		[]string{}, "Trusted Peers is the list of trusted peers for the client")
	rootCmd.PersistentFlags().BoolVarP(&client.Public, "public", "p",
		false, "Public is a flag that indicates if the client is public")
	rootCmd.PersistentFlags().StringVarP(&client.Name, "client-name", "c",
		"", "Client Name is the name of the client")
	rootCmd.PersistentFlags().StringVarP(&client.LogoURL, "logo-url", "l",
		"", "Client Logo URL is the URL of the client logo")
	rootCmd.PersistentFlags().StringVarP(&client.ObjectMeta.Namespace, "namespace", "n",
		"dex", "Namespace for the object")

	for _, requiredFlag := range []string{"id", "secret", "redirect-uris", "client-name"} {
		must(rootCmd.MarkPersistentFlagRequired(requiredFlag))
	}

	rootCmd.Run = func(cmd *cobra.Command, args []string) {
		client.ObjectMeta.Name = idToName(client.ID, func() hash.Hash { return fnv.New64() })
		yamlData, err := yaml.Marshal(&client)
		must(err)
		fmt.Printf(string(yamlData))
	}
	must(rootCmd.Execute())
}

func must(err error) {
	if err != nil {
		_, _ = fmt.Fprintln(os.Stderr, err)
	}
}
