# Load necessary libraries
library(ggplot2)

# Input Data: Customer spending habits
customers <- data.frame(
  Customer = c("A", "B", "C"),
  Product1 = c(2, 3, 5),
  Product2 = c(4, 6, 7),
  Product3 = c(6, 9, 8)
)

# 1. Normalize Spending
normalize <- function(vec) {
  return(vec / sqrt(sum(vec^2)))
}
customers_norm <- data.frame(
  Customer = customers$Customer,
  t(apply(customers[,-1], 1, normalize))
)
colnames(customers_norm)[-1] <- paste0("Normalized_", colnames(customers)[-1])

# 2. Calculate Similarity (Dot Product)
dot_product <- function(vec1, vec2) {
  return(sum(vec1 * vec2))
}
similarity_matrix <- matrix(0, nrow = nrow(customers), ncol = nrow(customers))
rownames(similarity_matrix) <- customers$Customer
colnames(similarity_matrix) <- customers$Customer

for (i in 1:nrow(customers)) {
  for (j in 1:nrow(customers)) {
    similarity_matrix[i, j] <- dot_product(
      as.numeric(customers[i, -1]),
      as.numeric(customers[j, -1])
    )
  }
}

# 3. Transformation (Matrix Multiplication)
weights <- matrix(c(1, 0, 0, 1, 1, 1), nrow = 3)
transformed_data <- as.matrix(customers[,-1]) %*% weights
colnames(transformed_data) <- c("Feature1", "Feature2")

# 4. Eigenvalues of Covariance Matrix
cov_matrix <- cov(as.matrix(customers[,-1]))
eigenvalues <- eigen(cov_matrix)$values
eigenvectors <- eigen(cov_matrix)$vectors

# Graphical Outputs

# a. Plot normalized data
norm_plot <- ggplot(customers_norm, aes(x = Normalized_Product1, y = Normalized_Product2, color = Customer)) +
  geom_point(size = 3) +
  theme_minimal() +
  labs(title = "Normalized Spending (Product1 vs Product2)", x = "Product1", y = "Product2")
print(norm_plot)

# b. Heatmap for Similarity Matrix
heatmap(similarity_matrix, Rowv = NA, Colv = NA, col = heat.colors(256), scale = "none", main = "Customer Similarity")

# c. Bar plot of Eigenvalues
eigen_plot <- ggplot(data.frame(Eigenvalues = eigenvalues, Component = 1:length(eigenvalues)), aes(x = Component, y = Eigenvalues)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  theme_minimal() +
  labs(title = "Eigenvalues of Covariance Matrix", x = "Component", y = "Eigenvalue")
print(eigen_plot)
