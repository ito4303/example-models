// supervised naive Bayes

data {
  // training data
  int<lower=1> K; // num topics
  int<lower=1> V; // num words
  int<lower=0> M; // num docs
  int<lower=0> N; // total word instances
  array[M] int<lower=1, upper=K> z; // topic for doc m
  array[N] int<lower=1, upper=V> w; // word n
  array[N] int<lower=1, upper=M> doc; // doc ID for word n
  // hyperparameters
  vector<lower=0>[K] alpha; // topic prior
  vector<lower=0>[V] beta; // word prior
}
parameters {
  simplex[K] theta; // topic prevalence
  array[K] simplex[V] phi; // word dist for topic k
}
model {
  // priors
  theta ~ dirichlet(alpha);
  for (k in 1 : K) {
    phi[k] ~ dirichlet(beta);
  }
  // likelihood, including latent category
  for (m in 1 : M) {
    z[m] ~ categorical(theta);
  }
  for (n in 1 : N) {
    w[n] ~ categorical(phi[z[doc[n]]]);
  }
}
