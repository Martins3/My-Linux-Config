/// <reference types="node" />
import { Duplex } from 'stream';
export declare class DevNull extends Duplex {
    _read(): void;
    _write(chunk: any, enc: any, cb: Function): void;
}
