# Iris Clustering Project

## Objective
Perform unsupervised K-means clustering on the Iris dataset to identify natural groupings of plants based on their sepal and petal measurements.

## Data
- **Source**: `data/iris.data`
- **Features (Measurements in cm)**: 
    - **Sepal**: The outer, drooping part of the flower (the "falls").
        - *Sepal Length*: Length of the sepal.
        - *Sepal Width*: Maximum width of the sepal.
    - **Petal**: The inner, upright part of the flower (the "standards").
        - *Petal Length*: Length of the petal.
        - *Petal Width*: Maximum width of the petal.
- **Target Classes**: 3 species (Setosa, Versicolour, Virginica) - used for evaluation only.

## Methodology
- **Data Validation**: Automated checks for missing values (NA) and non-numeric features.
- **Exploratory Analysis**: Elbow Method to determine the optimal number of clusters ($k$).
- **Algorithm**: K-means Clustering (Interactive $k$, default=3)
- **Preprocessing**: Feature selection (numeric attributes only).
- **Evaluation**: Visualization and comparison with actual species labels.

## References
1. **Fisher, R.A. (1936)**: *"The use of multiple measurements in taxonomic problems"*. Annual Eugenics, 7, Part II, 179-188. (The original source of the Iris dataset).
2. **Duda, R.O., & Hart, P.E. (1973)**: *"Pattern Classification and Scene Analysis"*. John Wiley & Sons. (Classical text on clustering theory).
3. **MacQueen, J. (1967)**: *"Some methods for classification and analysis of multivariate observations"*. Proceedings of the Fifth Berkeley Symposium on Mathematical Statistics and Probability. (Original K-means algorithm paper).
