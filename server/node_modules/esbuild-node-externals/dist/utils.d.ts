export declare const findPackagePaths: () => string[];
export declare const findDependencies: (options: {
    packagePaths: string[];
    dependencies: boolean;
    devDependencies: boolean;
    peerDependencies: boolean;
    optionalDependencies: boolean;
    allowList: string[];
}) => string[];
