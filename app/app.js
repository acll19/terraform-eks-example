const AWS = require("aws-sdk")
const express = require('express')

const app = express()
const port = 3000

app.get('/', (req, res) => {
  const name = req.query.name
  const s3 = new AWS.S3({
    accessKeyId: process.env.AWS_ACCESS_KEY,
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY
  })
  
  const params = {
    Bucket: process.env.S3_BUCKET_NAME,
    Key: "salute.json",
    Body: JSON.stringify({
      meta: 'Written from app running in EKS',
      salute: `Hello ${name}`
    })
  }
  
  s3.upload(params, (err, data) => {
    console.log(err, data)
  })
  
  res.send('Hello there! There is a surprise for you in S3, go get it!')
})

app.listen(port, () => {
  console.log(`Sample app listening at http://localhost:${port}`)
})

