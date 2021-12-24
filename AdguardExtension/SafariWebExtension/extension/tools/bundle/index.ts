import { program } from 'commander';

import { bundle } from './bundle';

program
    .option('-w, --watch', 'builds in watch mode', false);

program
    .action(() => {
        const options = program.opts();
        bundle(options.watch);
    });

program.parse();
