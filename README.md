# Movies App

Welcome to the **Movies App** repository! This project follows a **Clean Architecture** approach using **MVVM** and **Combine** to provide a scalable and maintainable iOS app. Below, you'll find all the necessary steps to set up and run the project.

## 📖 Architecture Overview

This app is built following **Clean Architecture** principles, keeping clear separations between layers:


For a detailed explanation, check out our **[Architecture Wiki](https://github.com/carlosmolina19/movies-code-challenge/wiki/Project-Architecture)**.

## 🚀 Setup Instructions

### 1️⃣ Clone the Repository
```sh
 git clone https://github.com/carlosmolina19/movies-code-challenge
```

### 2️⃣ Install Dependencies
Ensure you have **Homebrew** installed. If not, install it by following [this guide](https://brew.sh/).

#### Install Sourcery
```sh
brew install sourcery
```
Sourcery is used to generate **Mocks** automatically for testing.

### 3️⃣ Configure API Keys
This project uses The Movie Database (TMDB) API. To run the project, you need an API Key, which you can obtain from TMDB's official website:

🔗 [Get your API Key here](https://developer.themoviedb.org/docs/getting-started)

Once you have your API Key, add it to your `.xcconfig` files.

Create the following configuration files inside `Movies/`:

#### `Debug.xcconfig`
```sh
MOVIE_DB_SCHEME = https
MOVIE_DB_HOST = api.themoviedb.org
MOVIE_DB_API_VERSION = 3
TMDB_API_KEY = your_api_key_here
```

#### `Release.xcconfig`
```sh
MOVIE_DB_SCHEME = https
MOVIE_DB_HOST = api.themoviedb.org
MOVIE_DB_API_VERSION = 3
TMDB_API_KEY = your_api_key_here
```

> ⚠️ Make sure **Debug.xcconfig** and **Release.xcconfig** are **not committed** to version control.

### 4️⃣ Generate Mocks
Navigate to the **Sourcery** directory inside the project and run:
```sh
cd Movies/Sourcery
sourcery --config sourcery.yml
```

#### ❓ What if the `Generated` folder does not exist?
If the folder `MoviesTests/Mocks/Generated/` does not exist, **Sourcery will not create it automatically** and might result in errors. To avoid this, manually create the folder before running the command:
```sh
mkdir -p ../MoviesTests/Mocks/Generated
```

### 5️⃣ Run the App 🚀
Select the **Movies** target and run the project in Xcode.



---
Need help? Feel free to open an issue! 🚀

