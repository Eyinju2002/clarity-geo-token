;; GeoToken Implementation
(define-fungible-token geo-token)

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-unauthorized (err u101))
(define-constant err-invalid-location (err u102))

;; Data structures
(define-map locations
  { token-id: uint }
  { 
    latitude: int,
    longitude: int,
    timestamp: uint,
    owner: principal
  }
)

(define-map access-control
  { user: principal, viewer: principal }
  { can-view: bool }
)

;; Location recording
(define-public (record-location (token-id uint) (lat int) (long int))
  (let
    (
      (token-owner (unwrap! (get-token-owner token-id) err-unauthorized))
    )
    (if (is-eq tx-sender token-owner)
      (begin
        (map-set locations
          { token-id: token-id }
          {
            latitude: lat,
            longitude: long, 
            timestamp: block-height,
            owner: tx-sender
          }
        )
        (ok true)
      )
      err-unauthorized
    )
  )
)

;; Access control
(define-public (grant-access (to principal))
  (begin
    (map-set access-control
      { user: tx-sender, viewer: to }
      { can-view: true }
    )
    (ok true)
  )
)

(define-public (revoke-access (from principal))
  (begin
    (map-set access-control  
      { user: tx-sender, viewer: from }
      { can-view: false }
    )
    (ok true)
  )
)

;; Read functions
(define-read-only (get-location (token-id uint))
  (map-get? locations { token-id: token-id })
)

(define-read-only (can-view-location (owner principal) (viewer principal))
  (default-to 
    false
    (get can-view (map-get? access-control { user: owner, viewer: viewer }))
  )
)

(define-read-only (get-token-owner (token-id uint))
  (ok (ft-get-owner geo-token token-id))
)
