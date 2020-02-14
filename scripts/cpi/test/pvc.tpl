---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: storage-claim${i}
  labels:
    owner: christophe
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: clhcsi
  resources:
    requests:
      storage: 100Mi

