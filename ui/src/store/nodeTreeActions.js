import { get } from 'lodash'
import { nodeFromObject } from '../models'

export function lsRootFolder({ commit }) {
  return graph.query()
    .then(({ data }) => {
      const contents = data.root.filter(n => !n.deletedAt).map(nodeFromObject)
      contents.forEach(c => {
        commit('addNodeToParent', { parent: { id: 'root' }, child: c })
        commit('setNode', c)
      })
    })
    .catch(err => commit('setNetworkError', err))
}

export function ls({ dispatch, commit }, folderId = null) {
  if (!folderId || folderId === 'root') {
    return dispatch('lsRootFolder')
  }

  return graph.query({
    query: gql`
query LsFolder($folderId: String!) {
  node(id: $folderId) {
    ...basicNodeInfo
    ...basicBlobFileInfo

    parent {
      ...basicNodeInfo
    }

    ...on Folder {
      children {
         ...basicNodeInfo
         ...basicBlobFileInfo
      }
    }
  }
}

${basicNodeInfoFragment}
${basicBlobFileInfoFragment}
`,
    fragments: basicNodeInfoFragment,
    variables: {
      folderId
    }
  })
    .then(({ data }) => {
      const folder = nodeFromObject(data.node)
      const children = folder.children.filter(c => !c.deletedAt)
      folder.children = children.map(c => c.id)

      commit('setNode', folder)
      children.forEach(c => {
        commit('addNodeToParent', { parent: folder, child: c })
        commit('setNode', c)
      })
    })
    .catch(err => commit('setNetworkError', err))
}

export function performUpload({ state, getters, commit }) {
  const file = get(state, 'pendingUpload.file')
  const fileName = file.name
  const parentId = getters.activeFolder === 'root' ? null : getters.activeFolder

  return graph.mutate({
    mutation: gql`
mutation UploadFile($fileName: String!, $parentId: String) {
  uploadBlobFile(name: $fileName, parentId: $parentId) {
    ...basicNodeInfo
    ...basicBlobFileInfo
  }
}

${basicNodeInfoFragment}
${basicBlobFileInfoFragment}
`,
    fragments: [basicNodeInfoFragment, basicBlobFileInfoFragment],
    variables: {
      parentId,
      fileName,
      __UPLOAD__: file
    }
  })
    .then(({ data }) => {
      const node = nodeFromObject(data.uploadFile)
      commit('setNode', node)
      commit('addNodeToParent', {
        parent: { id: parentId || 'root' },
        child: node
      })
    })
    .catch(err => commit('setNetworkError', err))
}

export function createFolder({ commit, getters }, folderName) {
  const parentId = getters.activeFolder === 'root' ? null : getters.activeFolder

  return graph.mutate({
    mutation: gql`
mutation CreateFolder($folderName: String!, $parentId: String) {
  createFolder(name: $folderName, parentId: $parentId) {
    ...basicNodeInfo
  }
}

${basicNodeInfoFragment}
`,
    fragments: basicNodeInfoFragment,
    variables: {
      folderName,
      parentId
    }
  })
    .then(({ data }) => {
      const folder = nodeFromObject(data.createFolder)
      const { children } = folder
      folder.children = children.map(c => c.id)

      commit('setNode', folder)
      commit('addNodeToParent', {
        parent: { id: parentId || 'root' },
        child: folder
      })
      children.forEach(c => commit('setNode', c))
    })
    .catch(err => commit('setNetworkError', err))
}

export function deleteNode({ commit, getters }, { id }) {
  return graph.mutate({
    mutation: gql`
mutation DeleteNode($id: String!) {
  deleteNode(id: $id) {
    id

    parent {
      id
    }
  }
}`,
    variables: { id }
  })
    .then(({ data }) => {
      commit('removeNode', { id })

      const parentId = get(data, 'deleteNode.parent.id', 'root')
      const parent = getters.getNode(parentId)

      commit('patchNode', {
        id: parentId,
        patch: {
          children: parent.children.filter(c => c !== id)
        }
      })
    })
    .catch(err => commit('setNetworkError', err))
}
