apiVersion: extensions/v1beta1
kind: Deployment
metadata: 
  name: twitter-feed-v2
  labels:
    commit: ${WERCKER_GIT_COMMIT}
spec:
  replicas: 2
  selector:
    matchLabels:
      app: twitter-feed
  template:
    metadata:
      labels:
        app: twitter-feed
        commit: ${WERCKER_GIT_COMMIT}
        color: green
    spec:
      containers:
      - name: twitter-feed
        image: ${DOCKER_REGISTRY}/${DOCKER_REPO}:${WERCKER_GIT_BRANCH}-${WERCKER_GIT_COMMIT}
        imagePullPolicy: Always
        ports:
        - name: twitter-feed
          containerPort: 8080
          protocol: TCP
        volumeMounts:
          - name: podinfo
            mountPath: /tmp
            readOnly: false
      volumes:
        - name: podinfo
          downwardAPI:
            items:
            - path: "labels"
              fieldRef:
                fieldPath: metadata.labels
      imagePullSecrets:
        - name: wercker
---
apiVersion: v1
kind: Service
metadata:
  name: twitter-feed
  labels:
    app: twitter-feed
    commit: ${WERCKER_GIT_COMMIT}
spec:
  ports:
  - port: 30000
    targetPort: 8080
  selector:
    app: twitter-feed
    color: green
  type: ClusterIP
---
