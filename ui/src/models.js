import moment from 'moment'
import { assign } from 'lodash'

export const NodeTypes = {
  Node: 'Node',
  BlobFile: 'BlobFile',
  TextFile: 'TextFile',
  Folder: 'Folder'
}

const nodeFields = {
  id: '',
  name: '',
  createdAt: moment(),
  modifiedAt: moment(),
  deletedAt: null,
  private: true,
  previousVersions: [],
  parent: null,
  type: NodeTypes.Empty
}

export class Node {
  constructor(opts) {
    assign(this, nodeFields, opts)
  }
}

const folderFields = {
  type: NodeTypes.Folder,
  children: []
}

export class Folder extends Node {
  constructor(opts) {
    super(assign({}, folderFields, opts))
    this.children = this.children.map(nodeFromObject)
  }
}

const blobFileFields = {
  type: NodeTypes.BlobFile,
  mimeType: 'application/octet-stream',
  size: 0
}

export class BlobFile extends Node {
  constructor(opts) {
    super(assign({}, blobFileFields, opts))
  }
}

const textFileFields = {
  type: NodeTypes.TextFile,
  contents: ''
}

export class TextFile extends Node {
  constructor(opts) {
    super(assign({}, textFileFields, opts))
  }
}

export function nodeFromObject(node) {
  switch(node.type) {
    case NodeTypes.Node: return new Node(node)
    case NodeTypes.Folder: return new Folder(node)
    case NodeTypes.BlobFile: return new BlobFile(node)
    case NodeTypes.TextFile: return new TextFile(node)
    default: throw new Error(`unrecognized node type: ${node.type} ${JSON.stringify(node, null, '\t')}`)
  }
}
