/// <reference types="node" />
import { Transform } from 'stream';
export default class Buffered extends Transform {
    private chunks;
    private timer;
    constructor();
    sendData(): void;
    _transform(chunk: Buffer, encoding: any, callback: any): void;
    _flush(callback: any): void;
}
