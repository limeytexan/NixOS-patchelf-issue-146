package main

import (
	"net/http"
	"github.com/sirupsen/logrus"
)

type fooBar struct {
	log         *logrus.Logger
}

func (p *fooBar) doFooBar(w http.ResponseWriter, r *http.Request) bool {
	return true
}

func main() {
}
