/// <reference types="node" />
import { LoadPluginOptions } from './factory';
import { NvimPlugin } from './NvimPlugin';
export interface Response {
    send(resp: any, isError?: boolean): void;
}
export declare class Host {
    loaded: {
        [index: string]: NvimPlugin;
    };
    nvim: any;
    constructor();
    getPlugin(filename: string, options?: LoadPluginOptions): NvimPlugin;
    handlePlugin(method: string, args: any[]): Promise<any>;
    handleRequestSpecs(method: string, args: any[], res: Response): void;
    handler(method: string, args: any[], res: Response): Promise<void>;
    start({ proc }: {
        proc: NodeJS.Process;
    }): Promise<void>;
}
