function ci = estimate_cohens_d_ci(d,n1,n2)
% see Hedge LV, Olkin I. Statistical methods for meta-analysis. Orlando: Academic Press Inc; 2014. p. 86.
sigma_d = sqrt( ((n1+n2)./(n1*n2)) + (d^2./(2*(n1+n2))));
ci=[d - 1.96 * sigma_d, d + 1.96 * sigma_d];