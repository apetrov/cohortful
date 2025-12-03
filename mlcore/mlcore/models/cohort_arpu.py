import numpy as np
import pymc as pm
import pandas as pd

class CohortARPUModel:
    def __init__(self):
        self.model = None
        self.idata = None

    def fit(self, df_agg):
        df_agg['idx'], cats = pd.factorize(df_agg.cohort)
        coords = {'cohorts': cats}
        self.model = pm.Model(coords=coords)
        idx = df_agg.idx.values

        with self.model:
            mu_global = pm.Normal('mu_global', mu=np.log(1.2), sigma=0.3)
            sigma_global = pm.HalfNormal('sigma_global', sigma=0.3)

            log_mu = pm.Normal('log_mu',
                                        mu=mu_global,
                                        sigma=sigma_global,
                                        dims=('cohorts',),)

            k = pm.Gamma('k', mu=2, sigma=0.8, dims=('cohorts',))

            mu = pm.Deterministic('mu', pm.math.exp(log_mu),
                                           dims=('cohorts',))

            sigma_k = pm.HalfNormal('sigma_k', sigma=0.5)
            pm.Normal('y_sd', mu=k[idx] * mu[idx],sigma=sigma_k, observed=df_agg.revenue_sd.values)

            sigma_obs = k[idx] * mu[idx] / pm.math.sqrt(df_agg.installs.values)

            pm.Normal('y',
                      mu=mu[idx],
                      sigma=sigma_obs,
                      observed=df_agg.arpu.values)

            self.idata = pm.sample(500, target_accept=0.97)
