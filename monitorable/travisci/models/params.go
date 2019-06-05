//+build !faker

package models

type (
	BuildParams struct {
		Group      string `json:"group" query:"group"`
		Repository string `json:"repository" query:"repository"`
		Branch     string `json:"branch" query:"branch"`
	}
)

func (p *BuildParams) IsValid() bool {
	return p.Group != "" && p.Repository != "" && p.Branch != ""
}