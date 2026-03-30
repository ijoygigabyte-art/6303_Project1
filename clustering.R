# Define the file path - change this on your machine
file_path <- "f:/MASTERS/SEM2/6303/Project1/data/iris.data"

# Define column names
column_names <- c("sepal_length", "sepal_width", "petal_length", "petal_width", "class")

# --- Function Definitions ---

# Function to run K-means for a specific k
run_iris_clustering <- function(df, k = 3) {
    print(paste("Running K-means clustering with k =", k))

    # 1. Preprocessing: Select only numeric columns for clustering
    iris_features <- df[, 1:4]

    # 2. Perform K-means clustering
    set.seed(42) # For reproducibility
    iris_clusters <- kmeans(iris_features, centers = k, nstart = 20)

    # 3. Add cluster assignments to the original data
    df$cluster <- as.factor(iris_clusters$cluster)

    # 4. Evaluation: Compare clusters with actual species
    print("Confusion Matrix (Cluster vs. Actual Species):")
    print(table(df$cluster, df$class))

    # 5. Visualization
    if (require("ggplot2", quietly = TRUE)) {
        p <- ggplot(df, aes(x = petal_length, y = petal_width, color = cluster, shape = class)) +
            geom_point(size = 3, alpha = 0.8) +
            labs(
                title = paste("Iris Clustering (K-means, k =", k, ")"),
                subtitle = "Color = Cluster, Shape = Actual Species",
                x = "Petal Length (cm)",
                y = "Petal Width (cm)"
            ) +
            theme_minimal()

        file_name <- paste0("iris_clustering_k", k, ".png")
        ggsave(file_name, p, width = 8, height = 6)
        print(paste("Clustering plot saved as", file_name))
    } else {
        print("ggplot2 not found. Plotting with base R...")
        pch_values <- as.numeric(as.factor(df$class))
        plot(df$petal_length, df$petal_width,
            col = df$cluster, pch = pch_values,
            main = paste("Iris Clustering (k =", k, ")"),
            xlab = "Petal Length (cm)", ylab = "Petal Width (cm)"
        )
        legend("topleft", legend = levels(as.factor(df$class)), pch = seq_along(levels(as.factor(df$class))))
    }
}

# Function to run the Elbow Method
run_elbow_method <- function(df, max_k = 10) {
    print(paste("Running Elbow Method (k = 1 to", max_k, ")..."))
    iris_features <- df[, 1:4]
    wss <- numeric(max_k)

    for (k in 1:max_k) {
        set.seed(42)
        km <- kmeans(iris_features, centers = k, nstart = 20)
        wss[k] <- km$tot.withinss
    }

    # Visualization
    if (require("ggplot2", quietly = TRUE)) {
        elbow_df <- data.frame(k = 1:max_k, wss = wss)
        p <- ggplot(elbow_df, aes(x = k, y = wss)) +
            geom_line(color = "steelblue", size = 1) +
            geom_point(color = "steelblue", size = 3) +
            labs(
                title = "Elbow Method for Optimal k",
                subtitle = "Identifying the 'elbow' where WSS reduction slows down",
                x = "Number of Clusters (k)",
                y = "Total Within-Cluster Sum of Squares (WSS)"
            ) +
            theme_minimal() +
            scale_x_continuous(breaks = 1:max_k)

        ggsave("iris_elbow_plot.png", p, width = 8, height = 6)
        print("Elbow plot saved as 'iris_elbow_plot.png'")
    } else {
        plot(1:max_k, wss,
            type = "b", pch = 19, frame = FALSE,
            xlab = "Number of Clusters (k)", ylab = "Total WSS",
            main = "Elbow Method"
        )
    }
}

# --- Main Script Execution ---

if (file.exists(file_path)) {
    # Load data
    df <- read.csv(file_path, header = FALSE, col.names = column_names)
    print("Data loaded successfully!")
    print(head(df))

    # --- Data Validation ---
    print("Validating data...")
    
    # 1. Check for non-numeric features (first 4 columns)
    feature_cols <- 1:4
    non_numeric <- sapply(df[, feature_cols], function(x) !is.numeric(x))
    
    if (any(non_numeric)) {
        stop(paste("Error: Non-numeric data found in columns:", paste(column_names[feature_cols][non_numeric], collapse = ", ")))
    }
    
    # 2. Check for missing values (NA)
    na_counts <- colSums(is.na(df[, feature_cols]))
    if (any(na_counts > 0)) {
        print("Warning: Missing values (NA) detected:")
        print(na_counts[na_counts > 0])
        
        # Option: Remove rows with NAs
        print("Removing rows with missing values...")
        df <- df[complete.cases(df[, feature_cols]), ]
        print(paste("Remaining rows:", nrow(df)))
    } else {
        print("No missing values detected.")
    }
    print("Data validation complete.")

    # Interactive Menu
    cat("\nSelect an Analysis Option:\n")
    cat("1. Run Elbow Method (to find optimal k)\n")
    cat("2. Run K-means Clustering (with a specific k)\n")
    choice <- readline("Enter choice (1 or 2): ")

    if (choice == "1") {
        run_elbow_method(df)
    } else if (choice == "2") {
        k_input <- readline("Enter number of clusters (k) [default 3]: ")
        k_val <- ifelse(k_input == "", 3, as.numeric(k_input))
        if (is.na(k_val)) {
            print("Invalid input. Using default k = 3.")
            k_val <- 3
        }
        run_iris_clustering(df, k_val)
    } else {
        print("Invalid choice. Please run the script again and select 1 or 2.")
    }
} else {
    stop(paste("Error: File not found at", file_path))
}
