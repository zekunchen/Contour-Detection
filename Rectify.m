function rectified = Rectify(R,Gamma,rho)

    rectified = (1-exp(-R/rho))./(1+1/Gamma*exp(-R/rho));

end
