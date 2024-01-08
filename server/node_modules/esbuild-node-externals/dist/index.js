"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.nodeExternalsPlugin = void 0;
const utils_1 = require("./utils");
const nodeExternalsPlugin = (paramsOptions = {}) => {
    const options = {
        dependencies: true,
        devDependencies: true,
        peerDependencies: true,
        optionalDependencies: true,
        allowList: [],
        ...paramsOptions,
        packagePath: paramsOptions.packagePath && typeof paramsOptions.packagePath === 'string'
            ? [paramsOptions.packagePath]
            : paramsOptions.packagePath,
    };
    const nodeModules = (0, utils_1.findDependencies)({
        packagePaths: options.packagePath
            ? options.packagePath
            : (0, utils_1.findPackagePaths)(),
        dependencies: options.dependencies,
        devDependencies: options.devDependencies,
        peerDependencies: options.peerDependencies,
        optionalDependencies: options.optionalDependencies,
        allowList: options.allowList,
    });
    return {
        name: 'node-externals',
        setup(build) {
            build.onResolve({ namespace: 'file', filter: /.*/ }, (args) => {
                if (options.allowList.includes(args.path)) {
                    return null;
                }
                let moduleName = args.path.split('/')[0];
                if (args.path.startsWith('@')) {
                    const split = args.path.split('/');
                    moduleName = `${split[0]}/${split[1]}`;
                }
                if (nodeModules.includes(moduleName)) {
                    return { path: args.path, external: true };
                }
                return null;
            });
        },
    };
};
exports.nodeExternalsPlugin = nodeExternalsPlugin;
exports.default = exports.nodeExternalsPlugin;
//# sourceMappingURL=index.js.map