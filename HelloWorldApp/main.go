package main

import (
	"os"

	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()
	r.GET("/ping", func(c *gin.Context) {
		header := c.Request.Header.Get("X-TEST")
		c.JSON(200, gin.H{
			"message":       os.Getenv("MSG"),
			"X-TEST HEADER": header,
		})
	})
	r.Run(":8080") // listen and serve on 0.0.0.0:8080 (for windows "localhost:8080")
}
