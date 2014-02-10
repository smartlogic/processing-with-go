package main

import (
  "bytes"
  "fmt"
  "github.com/jpoehls/gophermail"
  "html/template"
)

var (
  smtpHost = "localhost:1025"
)

type Context struct {
  Name string
}

func main() {
  funcMap := template.FuncMap{
    "SayHello": SayHello,
  }

  tmplt, err := template.New("layout.html").Funcs(funcMap).ParseFiles("templates/layout.html", "templates/hello.html")
  if err != nil {
    return
  }

  var stringBuffer bytes.Buffer
  context := Context{"Eric"}
  tmplt.Funcs(funcMap).Execute(&stringBuffer, context)

  message := gophermail.Message{
    From:     "hi@example.com",
    To:       []string{"eric@example.com"},
    Subject:  "Hello!",
    HTMLBody: stringBuffer.String(),
  }

  gophermail.SendMail(smtpHost, nil, &message)
}

func SayHello(name string) (string) {
  return fmt.Sprintf("Hi %s", name)
}
