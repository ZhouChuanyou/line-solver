function W=qsys_gig1_approx_allencunneen(lambda,mu,ca,cs)
rho=lambda/mu;
W=(rho/(1-rho))/mu*((cs^2+ca^2)/2) + 1/mu;
end