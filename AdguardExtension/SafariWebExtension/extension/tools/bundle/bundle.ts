import { bundleRunner } from './bundle-runner';
import { config } from './webpack.config';

export const bundle = (watch = false) => {
    bundleRunner(config, watch);
};
