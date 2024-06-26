import Foundation

public class EnvironmentSettings {
  static let standard = EnvironmentSettings()

  var enviroment: String, appToken: String, secretKey: String, publicKey: String, privateKey: String

  private init() {
    enviroment = ""
    appToken = ""
    secretKey = ""
    publicKey = ""
    privateKey = ""
  }

  func changeEnvironment(env: String!) {
    self.enviroment = env
    getStorage()

  }

  func getStorage() {
    let storedObj = UserDefaults.standard.dictionary(forKey: self.enviroment)
    if storedObj != nil {
      self.appToken = storedObj!["appToken"] as! String
      self.secretKey = storedObj!["secretKey"] as! String
      self.publicKey = storedObj!["publicKey"] as! String
      self.privateKey = storedObj!["privateKey"] as! String
    } else {
      restoreDefault()
    }

  }

  func restoreDefault() {
    switch self.enviroment {
    case "dev":
      self.appToken =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBJZCI6MTIsImlhdCI6MTYyMDg4MjQ2NH0.DJfi52Dc66IETflV2dQ8G_q4oUAVw_eG4TzrqkL0jLU"
      self.secretKey = "34cfcd29432cdd5feaecb87519046e2d"
      self.publicKey =
        """
        -----BEGIN PUBLIC KEY-----
        MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAJi70XBS5+LtaCrNsrnWlVG6xec+J9M1
        DzzvsmDfqRgTIw7RQ94SnEBBcTXhaIAZ8IW7OIWkVU0OXcybQEoLsdUCAwEAAQ==
        -----END PUBLIC KEY-----
        """
      self.privateKey =
        """
        -----BEGIN RSA PRIVATE KEY-----
        MIIBOgIBAAJBAIA7GmDWkjuOQsx99tACXhOlJ4atsBN0YMPEmKhi9Ewk6bNBPvaX
        pRMWjn7c8GfWrFUIVqlrvSlMYxmW/XaATjcCAwEAAQJAKZ6FPj8GcWwIBEUyEWtj
        S28EODMxfe785S1u+uA7OGcerljPNOTme6iTuhooO5pB9Q5N7nB2KzoWOADwPOS+
        uQIhAN2S5dxxadDL0wllNGeux7ltES0z2UfW9+RViByX/fAbAiEAlCd86Hy6otfd
        k9K2YeylsdDwZfmkKq7p27ZcNqVUlBUCIQCxzEfRHdzoZDZjKqfjrzerTp7i4+Eu
        KYzf19aSA1ENEwIgAnyXMB/H0ivlYDHNNd+O+GkVX+DMzJqa+kEZUyF7RfECICtK
        rkcDyRzI6EtUFG+ALQOUliRRh7aiGXXZYb2KnlKy
        -----END RSA PRIVATE KEY-----
        """
      setStorage()
    case "sandbox":
      self.appToken =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBJZCI6OTUsImlhdCI6MTY1MTczMjM0Nn0.TFsg9wizgtWa7EbGzrjC2Gn55TScsJzKGjfeN78bhlg"
      self.secretKey = "b5d8cf6c30d9cb4a861036bdde44c137"
      self.publicKey =
        """
        -----BEGIN PUBLIC KEY-----
        MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAId28RoBckMTTPqVCC3c1f+fH+BbdVvv
        wDkSf+0zmaUlCFyQpassU3+8CvM6QbeYSYGWp1YIwGqg2wTF94zT4eECAwEAAQ==
        -----END PUBLIC KEY-----
        """
      self.privateKey =
        """
        -----BEGIN RSA PRIVATE KEY-----
        MIIBOwIBAAJBAMEKxNcErAKSzmWcps6HVScLctpdDkBiygA3Pif9rk8BoSU0BYAs
        G5pW8yRmhCwVMRQq+VhJNZq+MejueSBICz8CAwEAAQJBALfa29K1/mWNEMqyQiSd
        vDotqzvSOQqVjDJcavSHpgZTrQM+YzWwMKAHXLABYCY4K0t01AjXPPMYBueJtFeA
        i3ECIQDpb6Fp0yGgulR9LHVcrmEQ4ZTADLEASg+0bxVjv9vkWwIhANOzlw9zDMRr
        i/5bwttz/YBgY/nMj7YIEy/v4htmllntAiA5jLDRoyCOPIGp3nUMpVz+yW5froFQ
        nfGjPSOb1OgEMwIhAI4FhyvoJQKIm8wyRxDuSXycLbXhU+/sjuKz7V4wfmEpAiBb
        PmELTX6BquyCs9jUzoPxDWKQSQGvVUwcWXtpnYxSvQ==
        -----END RSA PRIVATE KEY-----
        """
      setStorage()
    case "production":
      self.appToken =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBJZCI6NDQsImlhdCI6MTY1MjIzMjEwM30.IMhz9dBDKJ736hTaxGaMJhJvQiq7Q1axsm6TiydspAU"
      self.secretKey = "0418d21948d904fb6f423998fd1e4714"
      self.publicKey =
        """
        -----BEGIN PUBLIC KEY-----
        MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAKRWwS+plGNWsiQiAMUJgBe7wdjhbAbx
        ZDBqKnAH9hZlRjrdgglBERzy/80/nL8cTI2FWAhEDaR3CewO+nRbaPECAwEAAQ==
        -----END PUBLIC KEY-----
        """
      self.privateKey =
        """
        -----BEGIN RSA PRIVATE KEY-----
        MIIBOgIBAAJBAI8rsaSa1cOzIDX/XsniS8TeZ9c1Kg0wqH4pIjUfL3z5X6lXDA3G
        g3uj/sdOJews6zDoXXxTHPkocPGdja98rb8CAwEAAQJAWRQOiyPrLMAeonopN+Mc
        0Xivky744wwLSbO+HN8yZMazvdvVCGjuXRXf9C2Et3sP5mcz1MlO2Zmq2xi0Lgc7
        QQIhANh5Z888Pv7dWr+s9o7SHoyeSAuO6NCUA0r2aaxNd+cDAiEAqU/hdSUeGicG
        HQl7chq14DImAbEplcGoT0l7Z/7aE5UCIQC7Z18XaXCf88G8bmCFBCKuWdjFKNMk
        vv6axvh00hwbQQIgcIPFMDQabQbB6UoD3zAg7XxmBXnWSM8JKqeKevHBuoECIG3A
        deJhhdalcQyJMTFIzx3r3+ANrkrd1v7VMsdFfaQ0
        -----END RSA PRIVATE KEY-----
        """
      setStorage()
    case "staging":
      self.appToken =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBJZCI6MTgsImlhdCI6MTYyNjkyOTQ1M30.RifF-H0C4w29WDRV0AGgP0qoffaAYbdmp_uyS69DEhI"
      self.secretKey = "1cf4df491c0972ff96fffb10327e4963"
      self.publicKey =
        """
        -----BEGIN PUBLIC KEY-----
        MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAIKTO8wcUDUEFK6c1xWmappjJTpSLR5+
        0y7j42/S07SdHknPOVVH/EnVj0UxoI+3AZloBwqgs7gV4DyMPHEZPX8CAwEAAQ==
        -----END PUBLIC KEY-----
        """
      self.privateKey =
        """
        -----BEGIN RSA PRIVATE KEY-----
        MIIBOQIBAAJAeEi2lnt0XYJBk068ncKYjG+C4dS1tZTxvVQrRKgzhrn5RY8NYhGR
        6rKI6SmfLuZfJwzJ7pAswHQcsZXq8bnFKQIDAQABAkAdt2Eclk1uWKLYwMgKdav4
        bgg4wLNPtAdxDd1Orftk2jBEzErHn8UEX5z1az1TEUpWvt0iPC3SDDtsJBI0pQ+t
        AiEAvkd9jsf6exffyG8Kjn/UGa//Xu7gv1FKhfK9+1i94N8CIQCh1D0b0IUHzPKC
        7F7N7IUeLGuLVMrT1xK78YbNi23y9wIgWI5jJCF0NPeugdUUH6/kYbQkcOVSGhhW
        S7LmsmThshcCIQCP+AFlfVzcU7hsQV0WVhUXgu0qR4UqcWx5R6ZltmVagQIgfYQl
        +kA7IIWCY7ist/xAmSAgmaitNYmfvPW8YnQp8fU=
        -----END RSA PRIVATE KEY-----
        """
      setStorage()
    default:
      Log.custom.push(title: "Restore default settings", message: "Không có environment!")

    }
  }

  func changeSettings(
    newAppToken: String!, newPrivateKey: String!, newPublicKey: String!, newSecretKey: String!
  ) {
    self.appToken = newAppToken
    self.privateKey = newPrivateKey
    self.publicKey = newPublicKey
    self.secretKey = newSecretKey
    setStorage()
  }

  func setStorage() {
    let newStoredData = [
      "appToken": self.appToken, "secretKey": self.secretKey, "publicKey": self.publicKey,
      "privateKey": self.privateKey,
    ]
    UserDefaults.standard.set(newStoredData, forKey: self.enviroment)
  }

}
