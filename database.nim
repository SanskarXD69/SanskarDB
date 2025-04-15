# My First Database Attempt!
# TODO: Learn proper error handling

import json, os, strutils

type
  Database* = object
    path*: string
    # Maybe use SQLite later? For now just files...
  
  DataItem* = object
    content*: string
    metadata*: JsonNode

proc newDatabase*(path: string): Database =
  ## Creates new database (just makes a folder)
  if not dirExists(path):
    createDir(path)
  result.path = path
  echo "DB created at: ", path # Temporary logging

proc addText*(db: var Database, text: string, meta: JsonNode) =
  ## Stores text with metadata (naive version)
  let id = $db.getNextId() # TODO: Implement ID system
  let metaFile = db.path / id & ".json"
  let contentFile = db.path / id & ".txt"
  
  # Save metadata
  writeFile(metaFile, $meta)
  # Save content
  writeFile(contentFile, text)
  echo "Added item ", id # Debug output

proc searchText*(db: Database, query: string): seq[string] =
  ## Basic search (super slow string matching)
  result = @[]
  for file in walkDir(db.path):
    if file.path.endsWith(".txt"):
      let content = readFile(file.path)
      if content.contains(query):
        result.add(content)
  echo "Found ", result.len, " results" # Temporary logging
