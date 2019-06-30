package main

import (
  "fmt"
  "log"
  "net/http"
  "encoding/json"
  "github.com/gorilla/mux"
)

type Article struct {
  Id int `json:"Id"`
  Title string `json:"Title"`
  Desc string `json:"desc"`
  Content string `json:"content"`
}

type Articles []Article

func homePage(w http.ResponseWriter, r *http.Request){
  fmt.Fprintf(w, "Welcome to the HomePage!")
  fmt.Println("Endpoint Hit: homePage")
}

func returnAllArticles(w http.ResponseWriter, r *http.Request){
  articles := Articles{}
  for i := 0; i < 10; i++ {
    title := "Hello_%d"
    articles = append(
      articles,
      Article{Id: i, Title: fmt.Sprintf(title, i), Desc: "Article Description", Content: "Article Content"})
  }
  fmt.Println("Endpoint Hit: returnAllArticles")
  json.NewEncoder(w).Encode(articles)
}

func returnSingleArticle(w http.ResponseWriter, r *http.Request){
  vars := mux.Vars(r)
  key := vars["id"]
  fmt.Fprintf(w, "Key: " + key + "\n")
}

func handleRequests() {
  myRouter := mux.NewRouter().StrictSlash(true)
  myRouter.HandleFunc("/", homePage)
  myRouter.HandleFunc("/articles", returnAllArticles)
  myRouter.HandleFunc("/article/{key}", returnSingleArticle)
  log.Fatal(http.ListenAndServe(":8082", myRouter))
}

func main() {
  fmt.Println("Rest API v2.0 - Mux Routers")
  handleRequests()
}
